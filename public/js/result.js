$(document).ready(function() {

  $('#group-search').keyup(function() {
    var query = $(this).val();

    if (autoSearch) {
      autoSearch.abort();
    }

    var autoSearch = $.ajax({
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

  $('#create-group-btn').click(function() {
    $.ajax({
      type: 'POST',
      url: '/create',
      data: {
        name: $('#group-search').val()
      },
      succes: function(data) {
        $('#group-search').after(data)
      }
    })
  })

  $('.group-name').click(function() {
    $('users-title').text(this.text());
  })

  $('#recommend a').click(function() {
    $('#group-search').val(this.text);
    $('#group-search').keyup();
  })
  



});