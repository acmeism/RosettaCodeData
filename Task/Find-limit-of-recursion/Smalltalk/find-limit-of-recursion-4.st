counter := 0.
down := [ counter := counter + 1. down value ].
down on: RecursionError do:[
   'depth is ' print. counter printNL
].
