n:1+-4?9
loop:{
  `1:"guess: ";g:(`i$-1_1:`)-48 / -48 to convert ascii digit codepoints to corresponding int values
  $[n~g;[`0:"yup!";`exit 0]
    (4=#g)&*/(g<10)&~g<0;`0:"bulls & cows: "," & "/$(b;(#g^g^n)-b:+/n=g)
    `0:"bad input"]}
{1}loop/0 / "while true: loop". 0 is a dummy arg
