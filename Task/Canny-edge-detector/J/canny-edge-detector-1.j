NB. 2D convolution, filtering, ...

convolve  =: 4 : 'x apply (($x) partition y)'
partition=: 2 1 3 0 |: {:@[ ]\ 2 1 0 |: {.@[ ]\ ]
apply=: [: +/ [: +/ *
max3x3 =: 3 : '(0<1{1{y) * (>./>./y)'
addborder =: (0&,@|:@|.)^:4
normalize =: ]%+/@,
attach =: 3 : 'max3x3 (3 3 partition (addborder y))'
unique =: 3 : 'y*i.$y'
connect =: 3 : 'attach^:_ unique y'

NB. on low memory devices, cropping or resampling of high-resolution images may be required
crop      =: 4 : 0
   'h w h0 w0' =: x
   |: w{. w0}. |: h{. h0}. y
)
resample  =: 4 : '|: (1{-x)(+/%#)\ |: (0{-x)(+/%#)\ y'
NB. on e. g. smartphones, image may need to be expanded for viewing
inflate1 =: 4 : 0
   'h w' =: $y
   r =: ,y
   c =: #r
   rr =: (c$x) # r
   (h,x*w)$rr
)
inflate =: 4 : '|: x inflate1 (|: x inflate1 y)'

NB. Step 1 - gaussian smoothing
step1 =: 3 : 0
   NB. Gaussian kernel (from Wikipedia article)
   <] gaussianKernel =: 5 5$2 4 5 4 2 4 9 12 9 4 5 12 15 12 5 4 9 12 9 4 2 4 5 4 2
   gaussianKernel =: gaussianKernel % 159
   gaussianKernel convolve y
)

NB. Step 2 - gradient
step2 =: 3 : 0
   <] gradientKernel =: 3 3$0 _1 0 0j_1 0 0j1 0 1 0
   gradientKernel convolve y
)

NB. Step 3 - edge detection
step3 =: 3 : 0
   NB. find the octant (eighth of circle) in which the gradient lies
   octant =: 3 : '4|(>.(_0.5+((4%(o. 1))*(12&o. y))))'
   <(i:6)(4 : 'octant (x j. y)')"0/(i:6)

   NB. is this gradient greater than [the projection of] a neighbor?
   greaterThan   =: 4 : ' (9 o.((x|.y)%y))<1'

   NB. is this gradient the greatest of immmediate colinear neighbore?
   greatestOf   =: 4 : '(x greaterThan y) *. ((-x) greaterThan y)'

   NB. relative address of neighbor relevant to grad direction
   krnl0 =. _1  0
   krnl1 =. _1 _1
   krnl2 =.  0 _1
   krnl3 =.  1 _1

   image =. y
   og =. octant image

   NB. mask for maximum gradient colinear with gradient
   ok0 =. (0=og) *. krnl0 greatestOf image
   ok1 =. (1=og) *. krnl1 greatestOf image
   ok2 =. (2=og) *. krnl2 greatestOf image
   ok3 =. (3=og) *. krnl3 greatestOf image
   image *. (ok0 +. ok1 +. ok2 +. ok3)
)

NB. Step 4 - Weak edge suppression
step4 =: 3 : 0
   magnitude =. 10&o. y
   NB. weak, strong threshholds
   NB. TODO: parameter picker algorithm or helper
   threshholds =. 1e14 1e15
   nearbyKernel =. 3 3 $ 4 1 4 # 1 0 1
   weak   =. magnitude > 0{threshholds
   strong =. magnitude > 1{threshholds
   strongs =. addborder (nearbyKernel convolve strong) > 0
   strong +. (weak *. strongs)
)

NB. given the edge points, find the edges
  step5 =: connect

canny =: step5 @ step4 @ step3 @ step2 @ step1
