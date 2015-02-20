putch=: 4 :0                 NB. coroutine verb
  outch y
  return x
)

isletter=: toupper ~: tolower

do_char=: 3 :0                 NB. coroutine verb
  ch=. getch''
  if. isletter ch do.
    if. odd do.
      putch&ch yield do_char '' return.
    end.
  else.
    odd=: -. odd
  end.
  return ch
)

evenodd=: 3 :0
  clear_outstream begin_instream y
  odd=: 0
  whilst. '.'~:char do.
    outch char=. do_char coroutine ''
  end.
)
