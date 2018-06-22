fft←{
    N←⍴⍵
    N≤1:⍵
    (1|2⍟N)≠0:'Argument must be a power of 2 in length'
    even←fft(N⍴0 1)/⍵
    odd←fft(N⍴1 0)/⍵
    k←N÷2
    T←even×*(0J¯2×(○1)×(¯1+⍳k)÷N)
    (odd+T),odd-T
}
