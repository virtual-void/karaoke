//Global variable to hold the list of rows
var data = [];

//Talks to sinatra server for new updates
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

function contains(a, obj) {
    var i = a.length;
    while (i--) {
       if (a[i].id === obj.id) {
           return true;
       }
    }
    return false;
}

//Parses JSON string
function parseJSON(arrayOfObjects) {
  for (var i = 0; i < arrayOfObjects.length; i++) {
    var object = arrayOfObjects[i];
    if (!contains(data, object)) {
      data.push(object);
      addRow(object['id'], object['table'], object['track']);
    } 
  }
}

function changeRow(index, table, track) {
  var new_row = '<tr><td>'+index+'</td><td>'+table+'</td><td>'+track+'</td></tr>';
  $('#karaoke > tbody > tr').eq(index-1).after(new_row);
}

//Adds a new row to the table
function addRow(id, table, track) {
  var new_row = '<tr><td>'+id+'</td><td>'+table+'</td><td>'+track+'</td></tr>';
  $('#karaoke tr:last').after(new_row);
}
