http = require 'http'

show_large_anagram_sets = (word_lst) ->
  anagrams = {}
  max_size = 0

  for word in word_lst
    key = word.split('').sort().join('')
    anagrams[key] ?= []
    anagrams[key].push word
    size = anagrams[key].length
    max_size = size if size > max_size

  for key, variations of anagrams
    if variations.length == max_size
      console.log variations.join ' '

get_word_list = (process) ->
  options =
    host: "wiki.puzzlers.org"
    path: "/pub/wordlists/unixdict.txt"

  req = http.request options, (res) ->
    s = ''
    res.on 'data', (chunk) ->
      s += chunk
    res.on 'end', ->
      process s.split '\n'
  req.end()

get_word_list show_large_anagram_sets
