require'stats'
wwhe=: {{
   ref=. /:~each words=. cutLF tolower fread 'unixdict.txt'
   y=.,y assert. 9=#y
   ch0=. 4{y
   chn=. (<<<4){y
   r=. ''
   for_i.2}.i.9 do.
     target=. <"1 ~./:~"1 ch0,.(i comb 8){chn
     ;:inv r=. r,words #~ ref e. target
   end.
}}
