NB. pad the edges of an array with border pixels
NB. (increasing the first two dimensions by 1 less than the kernel size)
pad=: {{
   rank=.#$m
   'first second'=. (<.,:>.)-:$m
    -@(second+rank{.$) {. (first+rank{.$){.]
}}

kernel_filter=: {{
   [: (0 >. 255 <. <.@:+&0.5) (1,:$m)+/ .*~&(,/)&m;._3 m pad
}}
