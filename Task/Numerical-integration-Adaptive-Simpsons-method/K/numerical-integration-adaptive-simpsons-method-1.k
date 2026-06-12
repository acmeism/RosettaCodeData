simpsonsRule:{[f;a;b] m: (a+b)%2; h: b-a; m, (h%6)*f[a]+f[b]+4*f[m]}

recursiveSimpson:{[f;a;b;tol;whole;m;depth]
 (lm;left): simpsonsRule[f;a;m]
 (rm;right): simpsonsRule[f;m;b]
 delta: left+right-whole
 tol2: tol%2
 $[(1>depth)|(tol2=tol)|~(15*tol)<delta|-delta
  left+right+delta%15
  recursiveSimpson[f;a;m;tol2;left;lm;depth-1]+recursiveSimpson[f;m;b;tol2;right;rm;depth-1]]}

quadAsr:{[f;a;b;tol;depth]; (m;whole): simpsonsRule[f;a;b]; recursiveSimpson[f;a;b;tol;whole;m;depth]}
