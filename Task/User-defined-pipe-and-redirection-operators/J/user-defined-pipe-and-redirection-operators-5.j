declare=: erase@boxopen
tee=: 4 :0
  if._1=nc boxopen x do.(x)=: '' end.
  (x)=: (do x),y
  y
)
grep=: 4 :'x (+./@E.S:0 # ]) y'
pipe=:2 :'v@(u"0)'  NB. small pipe -- spoon feed one record at a time
PIPE=:2 :0          NB. big pipe   -- feed everything all together
  v u y
:
  v (,x)"_ y        NB. syntactic sugar, beware of tooth decay
)
head=: {.
tail=: -@[ {. ]
sort=: /:~
uniq=: ~.
cat=:  ]
echo=: smoutput@;

declare;:'ALGOL_pioneers the_important_scientists'
aa=: ;do TXT=:0 :0 -.LF
  (
    (
      4 head data
    ),(
      cat pipe
      ('ALGOL'&grep) pipe
      ('ALGOL_pioneers'&tee)
        data
    ),(
      4 tail data
  )) ''PIPE
  sort PIPE
  uniq PIPE
  ('the_important_scientists'&tee) PIPE
  ('aa'&grep)
    ''
)

echo 'Pioneer:';aa
