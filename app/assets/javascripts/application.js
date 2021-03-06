// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require underscore
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require Chart.min

// Dynamically add alert to the page
var addAlert = function (text) {
  var html = "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>&times;</button>" + text + "</div>"
  $("#flash-alerts").append(html); 
}
