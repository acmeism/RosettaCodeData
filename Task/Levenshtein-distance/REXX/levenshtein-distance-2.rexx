Levenshtein: Procedure
Parse Arg s,t
/* for all i and j, d[i,j] will hold the Levenshtein distance between     */
/* the first i characters of s and the first j characters of t;           */
/* note that d has (m+1)*(n+1) values                                     */
  m=length(s)
  n=length(t)
  d.=0
  Do i=1 To m  /* source prefixes can be transformed into empty string by */
    d.i.0=i    /* dropping all characters                                 */
    End
  Do j=1 To n  /* target prefixes can be reached from empty source prefix */
    d.0.j=j    /* by inserting every character                            */
    End
  Do j=1 To n
    jj=j-1
    Do i=1 To m
      ii=i-1
      If substr(s,i,1)=substr(t,j,1) Then
        d.i.j=d.ii.jj          /* no operation required                   */
      else
        d.i.j=min(d.ii.j+1,,   /* a deletion                              */
                  d.i.jj+1,,   /* an insertion                            */
                  d.ii.jj+1)   /* a substitution                          */
      End
    End
  Say '          1st string  = '    s
  Say '          2nd string  = '    t
  say 'Levenshtein distance  = ' d.m.n;   say ''
  Return d.m.n
