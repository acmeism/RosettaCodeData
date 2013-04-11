makeRGB=: 0&$: : (($,)~ ,&3)
fillRGB=: makeRGB }:@$
setPixels=: (1&{::@[)`(<"1@(0&{::@[))`]}
getPixels=: <"1@[ { ]
