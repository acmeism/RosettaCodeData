context=:3 :0
  if. 0 = L. y do. context (,: ; ]) y return. end.
    kernel=. > {: y
    symbols=. (#$kernel) {. > {. y
    order=. /: symbols
    (symbols /: order); order |: kernel
)
symbols=: >@{.
kernel=: >@{:

zero=: context0x

monadic=: (1 :'[:context u@symbols; u&kernel')( :[:)
dyadic=:  (1 :'[:context ,&symbols; u&kernel')([: :)
successor=: +&1x monadic
equals=: -:&kernel
all=: i. >. %: kernel successor@$: ::] zero
is_member_of=: e.&(-. -.&all)&,&kernel ([: :)
exists_in=: 1&e.@e.&kernel ([: :)
not=: -. :[:
induction=:4 :0
   3 :'(y)=:context ?~#all'&.>;:x
   assert (#all) > #;._1 LF,y
   assert 0 = # y -.&;: LF,defined,x
   assert 0!:3 y
)

addition=: +/ dyadic
isN=: ([ assert@is_member_of&(context all))
even=: [: context kernel@addition~"0@,@kernel :[: @isN
odd=: successor@even

defined=: '(zero not exists_in odd successor equals is_member_of addition even)'
