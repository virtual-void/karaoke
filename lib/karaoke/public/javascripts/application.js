function update() {
  $("#server-name").html('Loading..');
  $.ajax({
    type: 'GET',
    url: '/update',
    timeout: 1000,
    success: function(data) {
      $("#server-name").html(data);
      window.setTimeout(update, 1000);
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $("#server-name").html('Timeout contacting server..');
      window.setTimeout(update, 60000);
    }
  });
}
