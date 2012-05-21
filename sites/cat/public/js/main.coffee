$ ->
  $('#editorabs').tabs()
  now.ready ->
    now.dbfind 'things', (things) ->
      console.log things
