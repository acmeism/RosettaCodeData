# The "master" file.

{ fork } = require 'child_process'
path = require 'path'
child_name = path.join __dirname, 'child.coffee'
words = [ 'Enjoy', 'Rosetta', 'Code' ]

fork child_name, [ word ] for word in words
