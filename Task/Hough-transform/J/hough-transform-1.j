NB.*houghTransform v Produces a density plot of image y in hough space
NB. y is picture as an array with 1 at non-white points,
NB. x is resolution (width,height) of resulting image
houghTransform=: dyad define
  'w h'=. x                               NB. width and height of target image
  theta=. o. (%~ 0.5+i.) w                NB. theta in radians from 0 to π
  rho=. (4$.$. |.y) +/ .* 2 1 o./theta    NB. rho for each pixel at each theta
  'min max'=. (,~-) +/&.:*: $y            NB. min/max possible rho
  rho=. <. 0.5+ h * (rho-min) % max-min   NB. Rescale rho from 0 to h and round to int
  |.([: <:@(#/.~) (i.h)&,)"1&.|: rho      NB. consolidate into picture
)
