digits=: 10&#.inv
sumdig=: +/@,@digits
notprime=: -.@(1&p:)
smith=: #~  notprime * (=&sumdig q:)every
