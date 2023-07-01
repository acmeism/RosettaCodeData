require'general/misc/prompt'
wordiff=: {{
  words=: cutLF tolower fread'unixdict.txt'
  c1=: prompt 'Name of contestant 1: '
  c2=: prompt 'Name of contestant 2: '
  hist=. ,word=. ({~ ?@#) (#~ 3 4 e.~ #@>) words
  echo 'First word is ',toupper;word
  echo 'each contestant must pick a new word'
  echo 'the new word must either change 1 letter or remove or add 1 letter'
  echo 'the new word cannot be an old word'
  while. do.
    next=. <tolower prompt 'Pick a new word ',c1,': '
    if. next e. hist do.
      echo next,&;' has already been picked'
      break.
    end.
    if. -. next e. words do.
      echo next,&;' is not in the dictionary'
      break.
    end.
    if. next =&#&> word do.
      if. 1~:+/d=.next~:&;word do.
        echo next,&;' differs from ',word,&;' by ',(":d),' characters'
        break.
      end.
    else.
      if. -. */1=(-&#&>/,[:+/=/&>/)(\:#@>) next,word do.
        echo next,&;' differs too much from ',;word
        break.
      end.
    end.
    hist=. hist,word=. next
    'c2 c1'=. c1;c2
  end.
  echo c2,' wins'
}}
