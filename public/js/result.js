$(document).ready(function() {

  $('#group-search').keyup(function() {
    var query = $(this).val();
    $.ajax({
      type: 'POST',
      url: '/search',
      data: {
        query: query
      },
      success: function(groupArray) {
        if(groupArray.length === 0) {
          $('.create-group').slideDown();
        } else {
          $('.create-group').slideUp();
        }
      }

    });
  });

});