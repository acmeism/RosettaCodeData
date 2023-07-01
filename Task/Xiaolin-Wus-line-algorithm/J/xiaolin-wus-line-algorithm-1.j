load'gl2'
coinsert'jgl2'

drawpt=:4 :0"0 1
   glrgb <.(-.x)*255 255 255
   glpixel y
)

drawLine=:3 :0 NB. drawline x1,y1,x2,y2
   pts=. 2 2$y
   isreversed=. </ |d=. -~/pts
   r=. |.^:isreversed"1
   pts=. /:~ pts \:"1 |d
   gradient=. %~/ (\:|)d

   'x y'=. |:pts
   xend=. <.0.5+ x
   yend=. y + gradient* xend-x
   xgap=. -.1|x+0.5

   n=. i. >: -~/ xend
   'xlist ylist'=. (n*/~1,gradient) + ({.xend),({.yend)
   weights=. ((2&}.,~ xgap*2&{.)&.(_1&|.) (,.~-.) 1|ylist)
   weights (drawpt r)"1 2 (,:+&0 1)"1 xlist,.<.ylist
)
