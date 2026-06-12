cputpct=:3 :0
  if. 0>nc<'PREVCPUTPCT' do. PREVCPUTPCT=:0 end.
  old=. PREVCPUTPCT
  PREVCPUTPCT=: (1+i.8){0".}:2!:0{{)nsed '2,$d' /proc/stat}}
  100*1-(3&{ % +/) PREVCPUTPCT - old
)
