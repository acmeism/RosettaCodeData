lzw = (s) ->
  dct = {} # map substrings to codes between 256 and 4096
  stream = [] # array of compression results

  # initialize basic ASCII characters
  for code_num in [0..255]
    c = String.fromCharCode(code_num)
    dct[c] = code_num
  code_num = 256

  i = 0
  while i < s.length
    # Find word and new_word
    #   word = longest substr already encountered, or next character
    #   new_word = word plus next character, a new substr to encode
    word = ''
    j = i
    while j < s.length
      new_word = word + s[j]
      break if !dct[new_word]
      word = new_word
      j += 1

    # stream out the code for the substring
    stream.push dct[word]

    # build up our encoding dictionary
    if code_num < 4096
      dct[new_word] = code_num
      code_num += 1

    # advance thru the string
    i += word.length
  stream

console.log lzw "TOBEORNOTTOBEORTOBEORNOT"
