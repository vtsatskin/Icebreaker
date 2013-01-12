$(document).ready(function() {

  var roomname = $.trim($('#users-title').text());
  $('#search-view').load('/room/' + roomname, function(data) {
    $(this).hide().fadeIn(500);
  });

  $('#group-search').keyup(function() {
    var query = $(this).val();
    if (autoSearch) {
      autoSearch.abort();
    }

    if (query == "") {
      $('.create-group').slideUp();
    }
    else {
      $('#create-group-btn').text('create ' + query.replace(/ /g,''));
      $('.create-group').slideDown();
    }

    var autoSearch = $.ajax({
      type: 'GET',
      url: '/search',
      data: {
        query: query
      },
      success: function(data) {
        $('#room-search').html(data);
        if ($.trim($('#room-search').children(0).children(0).html()) == query) {
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
