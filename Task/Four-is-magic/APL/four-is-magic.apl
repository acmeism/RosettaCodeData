magic←{
    t20←'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine'
    t20←t20,'ten' 'eleven' 'twelve' 'thirteen' 'fourteen' 'fifteen' 'sixteen'
    t20←t20,'seventeen' 'eighteen' 'nineteen'
    tens←'twenty' 'thirty' 'forty' 'fifty' 'sixty' 'seventy' 'eighty' 'ninety'
    spell←{
        ⍵=0:'zero'
        {
            ⍵=0:''
            ⍵<20:⍵⊃t20
            ⍵<100:∊tens[(⌊⍵÷10)-1],((0≠≢r)/'-'),r←∇10|⍵
            ⍵<1000:(∇⌊⍵÷100),' hundred',((0≠≢r)/' '),r←∇100|⍵
            ⍵<1e6:(∇⌊⍵÷1000),' thousand',((0≠≢r)/' '),r←∇1000|⍵
            ⍵<1e9:(∇⌊⍵÷1e6),' million',((0≠≢r)/' '),r←∇1e6|⍵
            ⍵<1e12:(∇⌊⍵÷1e9),' billion',((0≠≢r)/' '),r←∇1e9|⍵
            ⍵<1e15:(∇⌊⍵÷1e12),' trillion',((0≠≢r)/' '),r←∇1e12|⍵
            ⍵<1e18:(∇⌊⍵÷1e15),' quadrillion',((0≠≢r)/' '),r←∇1e15|⍵
            ⍵<1e21:(∇⌊⍵÷1e18),' quintillion',((0≠≢r)/' '),r←∇1e18|⍵
            'Overflow' ⎕SIGNAL 11
        }⍵
    }
    1(819⌶)@1⊢{
        n←spell ⍵
        ⍵=4:n,' is magic.'
        n,' is ',(spell ≢n),', ',∇≢n
    }⍵
}
