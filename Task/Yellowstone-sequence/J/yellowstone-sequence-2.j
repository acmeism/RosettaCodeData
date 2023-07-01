GCD=: +.
relatively_prime=: 1 = GCD

yellowstone=: {{
  s=. 1 2 3            NB. initial sequence
  while. y > # s do.
    z=. <./(1+s)-.s    NB. lowest positive inteeger not in sequence
    while. if. 0 1 -: z relatively_prime _2{.s do. z e. s end. do.
      z=. z+1
    end.   NB. find next value for sequence
    s=. s, z
  end.
}}
