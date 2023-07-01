   init =: 4 : '(1+x)$1'
length1 =: 4 : '1=#y'
      f =: 4 : ',/ +/\ (-x) ]\ y'

      1000 {  f ` init @. length1 / 1000 500 200 100 50 20 10 5 2 , 1000 0
327631322

NB. this is a foldLeft once initialised the intermediate right arguments are arrays
 1000 f 500 f 200 f 100 f 50 f 20 f 10 f 5 f 2 f (1000 init 0)
