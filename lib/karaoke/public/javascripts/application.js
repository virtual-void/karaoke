function update() {
  //$("#server-name").html('Loading..');
  $.ajax({
    type: 'GET',
    url: '/update',
    timeout: 1000,
    success: function(data) {
      //$("#server-name").html(data);
      parseJSON(data);
      window.setTimeout(update, 3000);
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $("#server-name").html('Timeout contacting server..');
      window.setTimeout(update, 60000);
    }
  });
}

function parseJSON(arrayOfObjects) {
  for (var i = 0; i < arrayOfObjects.length; i++) {
    var object = arrayOfObjects[i];
    // for (var property in object) {
    //      alert('item ' + i + ': ' + property + '=' + object[property]);
    // }
    // If property names are known beforehand, you can also just do e.g.
    // alert(object.id + ',' + object.Title);
    addRow(object['id'], object['table'], object['track']);
  }
}

function addRow(id, table, track) {
  var new_row = '<tr><td>'+id+'</td><td>'+table+'</td><td>'+track+'</td></tr>';
  $('#karaoke tr:last').after(new_row);
}
