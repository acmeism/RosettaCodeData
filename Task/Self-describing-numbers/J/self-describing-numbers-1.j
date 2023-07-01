   digits   =: 10&#.^:_1
   counts   =: _1 + [: #/.~ i.@:# , ]
   selfdesc =: = counts&.digits"0       NB.  Note use of "under"
