'R k ambient' =. 10 2 0.4
light =. (% +/&.:*:) 30 30 _50
pts =. (0&*^:(0={:))@:(,,(0>.(*:R)-+)&.*:)"0/~ i:15j200
luminosity =. (>:ambient) %~ (ambient * * +/&.:*:"1 pts) + k^~ 0>. R%~ pts +/@:*"1 -light

load 'viewmat'
togreyscale =. 256 #. [: <. 255 255 255 *"1 0 ]
'rgb' viewmat togreyscale luminosity
