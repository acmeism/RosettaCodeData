anagen=: {{
  seed=. (tolower y)([-.-.)a.{~97+i.26
  letters=. ~.seed
  list=. <;._2 tolower fread x
  ok1=. */@e.&letters every list
  ref=. #/.~seed
  counts=. <: #/.~@(letters,])every ok1#list
  ok2=. counts */ .<:ref
  c=. ok2#counts
  maybe=. i.1,~#c
  while. #maybe do.
    done=. (+/"2 maybe{c)*/ .=ref
    if. 1 e. done do.
      r=. ;:inv ((done#maybe) { ok2#I.ok1){L:0 1 <;._2 fread x
      if. #r=. r #~ -. r -:"1&tolower y do. r return. end.
    end.
    maybe=. ; c {{
      <(#~ n */ .<:"1~ [: +/"2 {&m) y,"1 0 ({:y)}.i.#m
    }} ref"1(-.done)#maybe
  end.
  EMPTY
}}
