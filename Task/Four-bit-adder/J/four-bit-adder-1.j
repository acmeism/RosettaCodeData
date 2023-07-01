and=: *.
or=: +.
not=: -.
xor=: (and not) or (and not)~
hadd=: and ,"0 xor
add=: ((({.,0:)@[ or {:@[ hadd {.@]), }.@])/@hadd
