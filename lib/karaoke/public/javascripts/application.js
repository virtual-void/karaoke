//Support for web sockets //////////////////////////////////////////////
// $(function(){
//   ws = new WebSocket("ws://localhost:5000/ws");
  
//   ws.onmessage = function(evt) {
//     _logInfo(evt.data);
//   };
  
//   ws.onclose = function() { 
//     ws.send("Leaves the chat");
//   };
  
//   ws.onopen = function() {
//     ws.send("Join the chat");
//   };
  
// });

// $(function() {
//   var eventSource = new EventSource('/stream');

//   eventSource.addEventListener('open', function() {
//     _logInfo("Connection opened");
// }, false);

// // An event without a type came in
// eventSource.addEventListener('message', function(event) {
//     var stockData = event.data;
//     _logInfo("Server says:"+ stockData);
// }, false);

// // EventSource lost connection or timed out
// eventSource.addEventListener('error', function() {
//     eventSource.close();
//     reinitiateEventSource();
// }, false);

// });

//Logging methods ////////////////////////////////////////////////////////
function _logDebug(text) {
    if (!window.console) {
        return;
    }

    console.log('Karaoke DEBUG: ' + text);
}

function _logInfo (text) {
    if (!window.console) {
        return;
    }

    console.log('Karaoke INFO: ' + text);
}

function _logWarn(text) {
    if (!window.console) {
        return;
    }

    console.log('Karaoke WARNING: ' + text);
}

function _logError(text) {
    if (!window.console) {
        return;
    }

    console.log('Karaoke ERROR: ' + text);
}


russianMessagesTable = {
    serverCommunicationError: 'Возникла непредвиденная ошибка при коммуникации с сервером',
    loadingMessage: 'Загрузка данных...',
    noDataAvailable: 'Данные недоступны!',
    addNewRecord: '+ Добавить запись',
    editRecord: 'Редактировать запись',
    areYouSure: 'Вы уверены?',
    deleteConfirmation: 'Эта запись будет удалена. Вы уверены?',
    save: 'Сохранить',
    saving: 'Сохранение',
    cancel: 'Отмена',
    deleteText: 'Удалить',
    deleting: 'Удаление',
    error: 'Ошибка',
    close: 'Закрыть',
    cannotLoadOptionsFor: 'Не могу загрузить опции для  {0}',
    pagingInfo: 'Показываю от {0} до {1} из {2} записей',
    canNotDeletedRecords: 'Не смог удалить {0} из {1} записей!',
    deleteProggress: 'Удалено {0} из {1} записей...'
  };

$('#ArtistTableContainer').jtable({
      messages: russianMessagesTable, //Localization
      title: 'Список исполнителей',
      selecting: true, //Enable selecting
      multiselect: true, //Allow multiple selecting
      selectingCheckboxes: true, //Show checkboxes on first column
      defaultSorting: 'status ASC',
      sorting: true,
      deleteConfirmation: function(data) {
        data.deleteConfirmMessage = 'Вы действительно хотите удалить запись?';
      },
      recordsLoaded: function(data) {
         $('#ArtistTableContainer .jtable > tbody > tr:nth-child(1)').addClass("jtable-row-highlited");
      },
      recordAdded: function(data) {
        $('#ArtistTableContainer').jtable('reload');
      },

      recordDeleted: function(data) {
        $('#ArtistTableContainer').jtable('reload');
      },

      recordUpdated: function(data) {
        $('#ArtistTableContainer').jtable('reload');
      },

      formCreated: function (event, data) {
        data.form.find('input[name="song_name"]').autocomplete({
        source: function (request, response) {
          $.ajax({
            url: "/SongList",
            dataType: "json",
            data: {
                term: request.term
            },
            type: "POST",
            success: function(data) {
              response(data);
            }
          });
        },
        minLength: 3
      }).focus();
      },

      actions: {
          listAction: '/ArtistList',
          createAction: '/CreateArtist',
          updateAction: '/UpdateArtist',
          deleteAction: '/DeleteArtist'
      },
      fields: {
          index: {
              key: true,
              title: '<№>',
              create: false,
              sorting: false,
              width: '5%',
              edit: false
          },
          id: {
              key: true,
              create: false,
              edit: false,
              list: false
          },
          status: {
              title: 'Статус',
              width: '10%',
              sorting: false,
              type: 'radiobutton',
              options: {'vip': 'VIP',  'outofturn': 'Вне очереди', 'paid': 'Платный', 'regular': 'Обычный'},
              defaultValue: 'vip'
          },
          table_id: {
              title: 'Столик',
              sorting: false,
              width: '20%',
              options: '/GetTableOptions'
          },
          song_name: {
              title: 'Песня',
              sorting: false,
              width: '50%'
          },
          record_date: {
              title: 'Дата добавления',
              width: '30%',
              type: 'date',
              sorting: false,
              create: false,
              edit: false,
              displayFormat: 'yy-mm-dd'
          }
      }
  });

  $('#ArtistTableContainer').jtable('load');
  //Delete selected students
  $('#DeleteAllButtonArtist').button().click(function () {
      var $selectedRows = $('#ArtistTableContainer').jtable('selectedRows');
      $('#ArtistTableContainer').jtable('deleteRows', $selectedRows);
  });

  $('#Reload').button().click(function () {
      $('#ArtistTableContainer').jtable('reload');
  });

//});

$('#TablesContainer').jtable({
  messages: russianMessagesTable, //Localization
  title: 'Список столиков',
  selecting: true, //Enable selecting
  multiselect: true, //Allow multiple selecting
  selectingCheckboxes: true, //Show checkboxes on first column
  deleteConfirmation: function(data) {
        data.deleteConfirmMessage = 'Вы действительно хотите удалить запись?';
  },
  actions: {
    listAction: '/TableList',
    createAction: '/CreateTable',
    updateAction: '/UpdateTable',
    deleteAction: '/DeleteTable'
  },
  fields: {
    id: {
      key: true,
      create: false,
      edit: false,
      list: false
    },
    name: {
      title: 'Название столика',
      width: '100%'
    }
  }});
  
$('#TablesContainer').jtable('load');
//Delete selected students
$('#DeleteAllButton').button().click(function () {
    var $selectedRows = $('#TablesContainer').jtable('selectedRows');
    $('#TablesContainer').jtable('deleteRows', $selectedRows);
});

function getImagePath(artist_status) {
      if (artist_status == "regular")
        return "/images/icons/mic_ico.png";
      if (artist_status == "vip")
        return "/images/icons/vip_ico.png";
      if (artist_status == "paid")
        return "/images/icons/dollar_ico.png";
      if (artist_status == "outofturn")
        return "/images/icons/hand_ico.png";
}

// $(document).ready(function(){
//         function debug(str) { $("#debug").append("<p>"+str+"</p>"); };

//         ws = new WebSocket("ws://localhost:8080/websocket");
//         ws.onmessage = function(evt) { $("#msg").append("<p>"+evt.data+"</p>"); };
//         ws.onclose = function() { debug("socket closed"); };
//         ws.onopen = function() {
//           debug("connected...");
//           ws.send("hello server");
//         };
// });


//Doesn't work yet correctly
function highlight_first_row()
{
   $('#karaoke > tbody tr:nth-child(1)').addClass("karaoke-row-highlited");
}

//Talks to sinatra server for new updates
function update() {
  $.ajax({
    type: 'GET',
    url: '/update',
    timeout: 3000,
    cache: false,
    success: function(data) {
      _logInfo("Loading data...")
      //$("#server-name").html(data);
      //$("#karaoke tbody > tr").remove();
      parseJSON(data);
      // window.setTimeout(update, 3000);
      highlight_first_row();
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
    //if (!contains(data, object)) {
      //data.push(object);
      updateRow(object['id'], object['index'], object['status'],object['table_name'], object['song_name']);
    //}
  }
}

function updateRow(id, index, status, table, track) {
  var new_row = $('<tr id=row_'+id+'><td class=hidden_id>'+id+'</td><td>'+index+'</td><td><img src=/images/icons/mic_ico.png border=0 width=45% height=40%></td><td>'+table+'</td><td>'+track+'</td></tr>');
  $('#row_'+index).replaceWith(new_row);
}

//Adds a new row to the table
function addRow(id, status, table, track) {
  var new_row = $('<tr><td>'+id+'</td><td><img src=/images/icons/mic_ico.png border=0 width=45% height=40%></td><td>'+table+'</td><td>'+track+'</td></tr>');
  // new_row.hide();
  $('#karaoke > tbody').append(new_row);
  // new_row.fadeIn(1000);
}
