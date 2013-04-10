exec = require('child_process').exec

for word in ["Enjoy", "Rosetta", "Code"]
    exec "echo #{word}", (err, stdout) ->
        console.log stdout
