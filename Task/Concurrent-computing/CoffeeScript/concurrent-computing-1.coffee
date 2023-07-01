{ exec } = require 'child_process'

for word in [ 'Enjoy', 'Rosetta', 'Code' ]
    exec "echo #{word}", (err, stdout) ->
        console.log stdout
