deck=: (25*1+i.4),2#1+i.10
deal=: 6&((?#){])@deck
targ=: 101+?@899
Pi=: ,~((#:I.@,)</~)i.
Va=: {{
  ok=. I#~(= 1>.>.)u&".&>/y{~|:I=. Pi N=.#y
  (N-1){."1 (y{~ok-."1~i.N),.<@(u expr)"1 ok{y
}}
Pa=: {{ if. 1<#;:y do. '(',y,')' else. y end. }}
expr=: {{ (Pa A),(;u`''),Pa B['A B'=.y }}
arith=: [:; <@(+Va, -Va, *Va, %Va,(-Va, %Va)@|.)"1
all=: {{ A#~x=".@>A=.~.,arith^:5 ":each y}}

task=: {{
   echo 'terms: ',":c=. /:~ deal ''
   echo 'target: ',":t=. targ ''
   echo '#solutions: ',":#a=. t all c
   echo 'for example: ',;{.a
}}
