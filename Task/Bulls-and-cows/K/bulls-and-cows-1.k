{1}{`1:"guess: ";g:(`i$-1_1:`)-48  / -48 to convert ascii digit codepoints to corresponding int values
    $[x~g;[`0:"yup!";`exit 0]
      (4=#g)&*/(g<10)&~g<0;[`0:"bulls & cows: "," & "/$(b;(#g^g^x)-b:+/x=g);x]
      [`0:"bad input";x]]}/1+-4?9  / argument is the same on every iteration
