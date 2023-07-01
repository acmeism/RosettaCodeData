cube  =: ($~ q:@#) :. ,
rou   =: ^@j.@o.@(% #)@i.@-:  NB. roots of unity
floop =: 4 : 'for_r. i.#$x do. (y=.{."1 y) ] x=.(+/x) ,&,:"r (-/x)*y end.'
fft   =: ] floop&.cube rou@#
