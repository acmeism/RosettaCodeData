NB. ref: http://www.jsoftware.com/pipermail/general/2005-August/024174.html
eq=:[:}:"1 [:($$[:([:+/\1:,}:~:}.),) ,&_"1                NB. equal numbers for atoms of y connected in first direction
eq_nd=: i.@#@$(<"0@[([:, |:^:_1"0 _)&> [:EQ&.> <@|:"0 _)] NB. n-dimensional eq, gives an #@$,*/@$ shaped matrix
repl=: (i.~{.){ {:@]                                      NB. replaces x by applying replace table y
cnnct=: [: |:@({."1<.//.]) [: ; <@(,.<./)/.~

findcontig_nd=: 3 : '($y)${.  ([:({.,~}:) ([ repl cnnct)/\.)^:([:+./@(~:/)2&{.)^:_ (,{.) eq_nd (i.~ ~.@,) y'
