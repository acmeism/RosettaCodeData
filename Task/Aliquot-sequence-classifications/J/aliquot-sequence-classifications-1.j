proper_divisors=: [: */@>@}:@,@{ [: (^ i.@>:)&.>/ 2 p: x:
aliquot=: +/@proper_divisors ::0:
rc_aliquot_sequence=: aliquot^:(i.16)&>
rc_classify=: 3 :0
      if. 16 ~:# y                 do. ' invalid        '
  elseif. 6 > {: y                 do. ' terminate      '
  elseif. (+./y>2^47) +. 16 = #~.y do. ' non-terminating'
  elseif. 1=#~. y                  do. ' perfect        '
  elseif. 8= st=. {.#/.~ y         do. ' amicable       '
  elseif. 1 < st                   do. ' sociable       '
  elseif. =/_2{. y                 do. ' aspiring       '
  elseif. 1                        do. ' cyclic         '
  end.
)
rc_display_aliquot_sequence=: (rc_classify,' ',":)@:rc_aliquot_sequence
