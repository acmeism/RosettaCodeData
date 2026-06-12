let s:word_dict = {}
for word in readfile('unixdict.txt')
  if strlen(word) > 5
    let s:word_dict[word] = substitute(word, 'e', 'i', 'g')
  endif
endfor
let s:word_list = []
for [key, value] in items(s:word_dict)
  if key != value && s:word_dict->has_key(value)
    call add(s:word_list, value .. " <- " .. key)
  endif
endfor
call append(line('$'), sort(s:word_list))
