padTri=: 0 ". ];._2                  NB. parse triangle and (implicitly) pad with zeros
maxSum=: [: {. (+ (0 ,~ 2 >./\ ]))/  NB. find max triangle path sum
