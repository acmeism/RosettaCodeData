proper_divisors =: [: */&> [: }: [: , [: { [: <@:({. ^ i.@:>:@:{:)";: [: |: 2 p: x:
aliquot =: ([: +/ proper_divisors) ::0:
rc_aliquot_sequence =: aliquot^:(i.16)&>
rc_classify =: [: {. ([;.1' invalid terminate non-terminating perfect amicable sociable aspiring cyclic') #~ (16 ~: #) , (6 > {:) , (([: +./ (2^47x)&<) +. (16 = #@:~.)) , (1 = #@:~.) , ((8&= , 1&<)@:{.@:(#/.~)) , ([: =/ _2&{.) , 1:
rc_display_aliquot_sequence =: (":,~' ',~rc_classify)@:rc_aliquot_sequence
