fft←{
    1>k←2÷⍨N←⍴⍵:⍵
    0≠1|2⍟N:'Argument must be a power of 2 in length'
    even←∇(N⍴0 1)/⍵
    odd←∇(N⍴1 0)/⍵
    T←even×*(0J¯2×(○1)×(¯1+⍳k)÷N)
    (odd+T),odd-T
}
