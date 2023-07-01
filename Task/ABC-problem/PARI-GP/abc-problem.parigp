BLOCKS = "BOXKDQCPNAGTRETGQDFSJWHUVIANOBERFSLYPCZM";
WORDS  = ["A","Bark","BOOK","Treat","COMMON","SQUAD","conFUSE"];

can_make_word(w) = check(Vecsmall(BLOCKS), Vecsmall(w))

check(B,W,l=1,n=1) =
{
  if (l > #W, return(1), n > #B, return(0));

  forstep (i = 1, #B-2, 2,
    if (B[i] != bitand(W[l],223) && B[i+1] != bitand(W[l],223), next());
    B[i] = B[i+1] = 0;
    if (check(B, W, l+1, n+2), return(1))
  );
  0
}

for (i = 1, #WORDS, printf("%s\t%d\n", WORDS[i], can_make_word(WORDS[i])));
