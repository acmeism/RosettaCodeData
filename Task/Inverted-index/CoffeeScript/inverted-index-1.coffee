fs = require 'fs'

make_index = (fns) ->
  # words are indexed by filename and 1-based line numbers
  index = {}
  for fn in fns
    for line, line_num in fs.readFileSync(fn).toString().split '\n'
      words = get_words line
      for word in words
        word = mangle(word)
        index[word] ||= []
        index[word].push [fn, line_num+1]
  index

grep = (index, word) ->
  console.log "locations for '#{word}':"
  locations = index[mangle(word)] || []
  for location in locations
    [fn, line_num] = location
    console.log "#{fn}:#{line_num}"
  console.log "\n"

get_words = (line) ->
  words = line.replace(/\W/g, ' ').split ' '
  (word for word in words when word != '')

mangle = (word) ->
  # avoid conflicts with words like "constructor"
  '_' + word

do ->
  fns = (fn for fn in fs.readdirSync('.') when fn.match /\.coffee/)
  index = make_index(fns)
  grep index, 'make_index'
  grep index, 'sort'
