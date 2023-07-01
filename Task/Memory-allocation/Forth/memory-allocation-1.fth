unused .  \ memory available for use in dictionary
here .    \ current dictionary memory pointer
: mem, ( addr len -- ) here over allot swap move ;
: s, ( str len -- ) here over char+ allot place align ;   \ built-in on some forths
: ,"  [char] " parse s, ;
variable num
create array  60 cells allot
create struct  0 , 10 ,  char A c,  ," string"
unused .
here .
