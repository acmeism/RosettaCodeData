      ⎕CY 'dfns' ⍝ import dfns namespace
                 ⍝ pco ← prime finder
                 ⍝ nats ← natural number arithmetic (uses strings)
      ⍝ Get all Wieferich primes below n:
      wief←{{⍵/⍨{(,'0')≡(×⍨⍵)|nats 1 -nats⍨ 2 *nats ⍵-1}¨⍵}⍸1 pco⍳⍵}
      wief 5000
1093 3511
