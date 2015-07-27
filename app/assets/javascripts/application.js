// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$( document ).ready(function() {
    $('#about').on('click', function(e){
      e.preventDefault();
      $('#modalAbout').modal();
    });

    $('#rules').on('click', function(e){
      e.preventDefault();
      $('#modalRules').modal();
    });   


    $('.destroy_record').on('click', function(e){
      var link = $(this),
          td = link.closest('td'),
          tr = td.closest('tr'),
          currentUserNameId = link.closest('tbody').attr('data-current-user'),
          albumId = link.attr('data-album-id');

      $.ajax({
        url: '/users/' + currentUserNameId + '/albums/' + albumId,
        type: 'POST',
        data: { _method: 'DELETE' },
        success: function(result){
          console.log('del ok');
          tr.fadeOut(1000);
          $('.notice_area').html('<div class="alert  alert-success">album is added successfull.</div>');     
        },
        error: function(xhr, ajaxOptions, thrownError){
          $('.notice_area').html('<div class="alert  alert-error">album is added failed.</div>');   
          console.log(xhr.status);
          console.log(thrownError);
        }        
      })
    });   

});


