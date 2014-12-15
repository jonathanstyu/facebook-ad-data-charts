$(document).ready(function () {
	$(document).on('click', '.header', function (click) {
	  $(click.target).remove(); 
	}); 

	$(document).on('click', '.list-group-item', function (click) {
	  var value = $(click.target).text()
  
	  if($(click.target).hasClass('dimension')) {
    
	    // if we have too many spans, remove the first one
	    if ($("#dimensions-header > button").length == 2) {
	      $("#dimensions-header button:first-child").remove()
	    }
    
	    // Attach span to panel
	    var dimensionHTML ="<button class='btn btn-xs btn-success header'>" + value + "</button>"
	    $('#dimensions-header').append(dimensionHTML)              
	  } else {
    
	    // if we have too many spans, remove the first one
	    if ($("#metrics-header > span").length == 2) {
	      $("#metrics-header button:first-child").remove()
	    }
    
	    // Attach span header
	    var measureHTML ="<button class='btn btn-xs btn-warning header'>" + value + "</span>"
	    $('#metrics-header').append(measureHTML)
	  }
	});

	// $('#results-table').DataTable(); 
	
	$(document).on('click', '#download', function (click) {
		var csvContent = 'data:text/csv;charset=utf-8,'
		var data = [["cats", "dogs", "pigeons"],[3, 3, 3]]
		data.forEach(function (csvArray, index) {
			dataString = csvArray.join(',')
			csvContent += dataString + '\n'; 
		})
		
		var encodedURI = encodeURI(csvContent)
		window.open(encodedURI)
	}); 

	$(document).on('click', '#run', function (click) {
	  var url = $(location).attr('href')
	  var startDate = $('#startDate').val()
	  var endDate = $('#endDate').val()
	  var dimensions = ""
	  var metrics = ""
  
	  // The following two chunks parses and adds the params 
	  $('#dimensions-header > button').each(function (i, span) {
	    if (dimensions.length > 0) {
	      dimensions = dimensions + "," + $(span).text()
	    } else {
	      dimensions = $(span).text()
	    }
	  }); 
  
	  $('#metrics-header > button').each(function (i, span) {
	    if (metrics.length > 0) {
	      metrics = metrics + "," + $(span).text()
	    } else {
	      metrics = $(span).text()
	    }
	  })
  
	  if(startDate.length == 0 || endDate.length == 0) {
	    addAlert("Invalid Selection"); 
	  } else {
    
	    // Build the query params
	    url = url + 
	      "&start_date=" + startDate + 
	      "&end_date=" + endDate +
	      "&metrics=" + metrics        
  
	    // Because GA API only requires metrics, if there are no dimensions to be added, don't add the query string
	    if (dimensions.length > 0) {
	      url = url + "&dimensions=" + dimensions
	    }
    
	    window.location = url
	  }
	})
	
})