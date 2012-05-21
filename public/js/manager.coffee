 $ ->
  now.ready ->
    now.dbfind 'sites', (sites) ->
      console.log sites
