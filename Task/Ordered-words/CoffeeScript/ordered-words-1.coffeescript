ordered_word = (word) ->
  for i in [0...word.length - 1]
    return false unless word[i] <= word[i+1]
  true

show_longest_ordered_words = (candidates, dict_file_name) ->
  words = ['']
  for word in candidates
    continue if word.length < words[0].length
    if ordered_word word
      words = [] if word.length > words[0].length
      words.push word
  return if words[0] == '' # we came up empty
  console.log "Longest Ordered Words (source=#{dict_file_name}):"
  for word in words
    console.log word

dict_file_name = 'unixdict.txt'
file_content = require('fs').readFileSync dict_file_name
dict_words = file_content.toString().split '\n'
show_longest_ordered_words dict_words, dict_file_name
