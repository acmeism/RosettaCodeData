mt=:{{ (? 0) I.~ +/\ (y { x) }}				NB. Mutate state function
pad=:0,0,~0(,.)0,.~]						NB. Pading with zero
ib=:+./@:(=&2)@,							NB. IsBurning to check if fire in the area
f=:0.005									NB. Probability of starting fire
p=:0.05										NB. Probability of three
tm0=:3 3$(1-p),p,0,0,(1-f),f,1,0,0			NB. Transition matrix of state with no fire in area
tm1=:3 3 $(1-p),p,0,0,0,1,1,0,0				NB. Transition matrix of state with fire in area
		
opt0=:[:tm0&mt(<1 1){]						NB. Option #0 (for mutation with no fire in area)
opt1=:[:tm1&mt(<1 1){]						NB. Option #1 (for mutation with fire in area)

ff=:(,.~1 3)([: pad(opt0`opt1@.ib);._3)]	NB. Core function FireForest

											NB. Using it....
dt =: 10 10 $ 0								NB. Create a empty 10x10 matrix
ff ^:(i.100) dt								NB. Iterate 100 time, output include initial empty matrix.
