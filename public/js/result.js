$(document).ready(function() {

  if ($('#users-title').html() != 'Choose a Room') {
      $.ajax({
      type: 'GET',
      url: '/room',
      data: {
        roomname: $('#users-title').html()
      },
      success: function(data) {
        $('#search-view').html(data);
      }
    });
  }

  $('#group-search').keyup(function() {
    
    var query = $(this).val();

    if (autoSearch) {
      autoSearch.abort();
    }

    if (query == "") {
      $('.create-group').slideUp();
    }
    else {
      $('#create-group-btn').text('create ' + query);
      $('.create-group').slideDown();
    }

    var autoSearch = $.ajax({
      type: 'GET',
      url: '/search',
      data: {
        query: query
      },
      success: function(data) {
        console.log(data);
        $('#room-search').html(data);
        if ($('#room-search').children(0).children(0).html() == query) {
          $('.create-group').slideUp();
        }
      }
    });
  });

  $('#group-search').keyup();

  $('#create-group-btn').click(function() {
    $.ajax({
      type: 'POST',
      url: '/create',
      data: {
        name: $('#group-search').val()
      },
      success: function(data) {
        $('#room-search').prepend(data);
      }
    });
  });

  $('.room').click(function() {
    alert('up');
    $('#users-title').text($(this).text());
  });

  $('#recommend a').click(function() {
    $('#group-search').val(this.text);
    $('#group-search').keyup();
  });
});
