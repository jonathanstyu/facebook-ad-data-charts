var ready = function () {
  
  var chartElements = new Object()
  var receivedFBData = new DataObject()
  var that = this 
  Chart.defaults.global.responsive = true
  Chart.defaults.global.maintainAspectRatio = false
    
  $("canvas").each(function (index, element) {
    
    // Parse the ID for the name of the content that will be in the chart
    var canvasID = $(element).attr("id").split("-")[0]
    var canvasElement = new Chart($(element).get(0).getContext("2d"))
      
    canvasElement.Line({
      labels: [""],
      datasets: [
          {
            label: canvasID,
            data: [0]
          }
        ]
    }) // Close the Chart.Line 
    
    chartElements[canvasID] = canvasElement
  })
  
        
  $("#fbdatasubmit").submit(function (event) {
    event.preventDefault();
    var formArray = $(this).serialize()
    var url = $(event.target).attr("url") + "?"
    url = url + formArray.toString()
    
    // This code segment is for handling future customization where someone wants to specify what they want to specify their columns 
    // var formArray = $(this).serializeArray()
    // var dataColumns = []
    //
    // for (var i = formArray.length - 1; i >= 0; i--) {
    //   if (formArray[i].name === "data_columns" ) {
    //     dataColumns.push("'" + formArray[i].value.toString() + "'")
    //   } else {
    //     url = url + formArray[i].name + "=" + formArray[i].value
    //   }
    // }
    // url = url + "&" + "data_columns=" + dataColumns.toString()
    

    $.ajax({
      url: url
    }).done(function (data) {
      populateChart(data)
    })
  })
  
  // callback function for the data success function
  var populateChart = function (data) {
    if (data['error']) {
      addAlert("An Error Has Occurred. Check your FB Account ID")
    }
    
    that.receivedFBData = new DataObject(data.data);
    that.receivedFBData.processRawData()    
    populateStatistics(that.receivedFBData)
    
    console.log(that.receivedFBData)
    
    // The goal here is to iterate through the global Object of IDs and Charts created earlier "chartElements" and replace each one with the new, downloaded values from the API
    _.each(chartElements, function (chart, id) {
      var rawData = that.receivedFBData.returnChartJSArray(id)
      
      chart.Line({
        // Tried to figure out a way to do this in an elegant "update" way but none such
        labels: that.receivedFBData.returnChartJSArray("date_start"),
        datasets: [
            {
              label: id,
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: rawData
            }
          ]
    }) // Close the Chart.Line function
    }) // Close the _.each 
  }
  
  // Click to download data
	$(document).on('click', '.downloadbutton', function (click) {
    
    // Create an error handling message that makes sure we don't try to write nonexistent data
    if (that.receivedFBData && that.receivedFBData.dataPresent === true) {
      var metricDownloaded = $(click.target).attr("id").split("-")[0]
      that.receivedFBData.downloadToCSV(metricDownloaded)
      
    } else {
      addAlert("No Data To Download")
    }
	}); 
  
  var populateStatistics = function (dataObject) {
    // Process statistics and fill them in 
    $('.totalspan').each(function (index, object) {
      var itemToTotal = $(object).attr('id').split('-')[0]
      $(object).text(dataObject.calculateTotal(itemToTotal))
    })
    
    $('.avgspan').each(function (index, object) {
      var itemToAverage = $(object).attr('id').split('-')[0]
      $(object).text(dataObject.calculateAverage(itemToAverage))
    })
  }
  
  // Javascript Object for receiving and performing calculations on received data
  function DataObject(returnedJSON) {
    this.rawData = returnedJSON
    this.dataPresent = false
    this.data = new Array()
    
    
    this.processRawData = function () {
      var there = this
      this.rawData.forEach(function (node) {
        var node = new DataNode(node)
        there.data.push(node)
      })
      
      this.dataPresent = true
    }
                
    // Delivers data in a format acceptable for Chart.js
    this.returnChartJSArray = function (key) {      
      var keyArray = new Array()
      var there = this
        
      for (var i = there.data.length - 1; i >= 0; i--) {
        if (Array.isArray(there.data[i][key])) {
          
        } else {
          keyArray.push(there.data[i][key])
        }
      }
      return keyArray.reverse()        
    } // close ChartJS loop 
    
    this.returnRollingAverageArray = function (key, toRoll) {
      var valuesArray = this.returnChartJSArray(key)
      var averageArray = new Array(valuesArray.length)
      var there = this
        
      for (var i = 0; i < averageArray.length; i++) {
        if (i < toRoll) {
          averageArray[i] = ""
        } else {
          var sumToAverage = 0 
          for (var r = 0; r < toRoll; r++) {
            sumToAverage += valuesArray[i - r]
          }
        
          averageArray[i] = sumToAverage / toRoll
        }
      }
            
      return averageArray
    } // close Rolling Average Array
    
    this.downloadToCSV = function (key) {
  		var csvContent = 'data:text/csv;charset=utf-8,'
  		var dataToDownload = new Array()
    
      dataToDownload[0] = this.returnChartJSArray('date_start')
      dataToDownload[1] = this.returnChartJSArray(key)
      
      csvContent += "date," + key + '\n'
        
      dataToDownload[0].forEach(function (csvArray, index) {
        dataString = dataToDownload[0][index] + ',' + dataToDownload[1][index]
        csvContent += dataString + '\n';
      })

      var encodedURI = encodeURI(csvContent)
      window.open(encodedURI)
    }
    
    this.calculateTotal = function (key) {
      var total = 0.0
      this.data.forEach(function (node) {
        total += node[key]
      })
      
      return total.toFixed(1)
    }

    this.calculateAverage = function (key) {
      var average = 0.0
      this.data.forEach(function (node) {
        average += node[key]
      })
      
      average = (average / this.data.length)
      
      return average.toFixed(1)
    }    
    
  } // close DataObject
  
  function DataNode(nodeJSON) {
    var there = this 
      
    // Maps the JSON to an object so that we can run calculations to it
    Object.keys(nodeJSON).forEach(function (key) {
      there[key] = nodeJSON[key]
    })
  }
  
}

$(document).ready(ready)
$(document).on('page:load', ready)