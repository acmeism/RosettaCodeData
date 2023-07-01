readchar=:3 :0
  if.0=#INBUF do. INBUF=:LF,~1!:1]1 end.
  r=.3 u:{.INBUF
  INBUF=:}.INBUF
  r
)

writechar=:3 :0
  OUTBUF=:OUTBUF,u:y
)

subleq=:3 :0
  INBUF=:OUTBUF=:''
  p=.0
  whilst.0<:p do.
    'A B C'=. (p+0 1 2){y
    p=.p+3
    if._1=A do. y=. (readchar'') B} y
    elseif._1=B do. writechar A{y
    elseif. 1   do.
      t=. (B{y)-A{y
      y=. t B}y
      if. 0>:t do.p=.C end.
    end.
  end.
  OUTBUF
)
