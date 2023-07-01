      ⍝ We know that 99,736 is a valid answer, so we only need to test the positive integers from 1 up to there:
      N←⍳99736
      ⍝ The SQUARE OF omega is omega times omega:
      SQUAREOF←{⍵×⍵}
      ⍝ To say that alpha ENDS IN the six-digit number omega means that alpha divided by 1,000,000 leaves remainder omega:
      ENDSIN←{(1000000|⍺)=⍵}
      ⍝ The SMALLEST number WHERE some condition is met is found by taking the first number from a list of attempts, after rearranging the list so that numbers satisfying the condition come before those that fail to satisfy it:
      SMALLESTWHERE←{1↑⍒⍵}
      ⍝ We can now ask the computer for the answer:
      SMALLESTWHERE (SQUAREOF N) ENDSIN 269696
