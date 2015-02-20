/* REXX ---------------------------------------------------------------
* 07.08.2014 Walter Pachl translated from PL/I)
*--------------------------------------------------------------------*/
  Numeric Digits 20
  Parse Arg t
  n=3
  Parse Value '1  2  3 14' With a.1.1 a.1.2 a.1.3 b.1
  Parse Value '2  1  3 13' With a.2.1 a.2.2 a.2.3 b.2
  Parse Value '3 -2 -1 -4' With a.3.1 a.3.2 a.3.3 b.3
  If t=6 Then Do
    n=6
    Parse Value '1.00 0.00 0.00  0.00  0.00 0.00  ' With a.1.1 a.1.2 a.1.3 a.1.4 a.1.5 a.1.6 .
    Parse Value '1.00 0.63 0.39  0.25  0.16 0.10  ' With a.2.1 a.2.2 a.2.3 a.2.4 a.2.5 a.2.6 .
    Parse Value '1.00 1.26 1.58  1.98  2.49 3.13  ' With a.3.1 a.3.2 a.3.3 a.3.4 a.3.5 a.3.6 .
    Parse Value '1.00 1.88 3.55  6.70 12.62 23.80 ' With a.4.1 a.4.2 a.4.3 a.4.4 a.4.5 a.4.6 .
    Parse Value '1.00 2.51 6.32 15.88 39.90 100.28' With a.5.1 a.5.2 a.5.3 a.5.4 a.5.5 a.5.6 .
    Parse Value '1.00 3.14 9.87 31.01 97.41 306.02' With a.6.1 a.6.2 a.6.3 a.6.4 a.6.5 a.6.6 .
    Parse Value '-0.01 0.61 0.91 0.99 0.60 0.02'    With b.1 b.2 b.3 b.4 b.5 b.6 .
    End
  Do i=1 To n
    Do j=1 To n
      sa.i.j=a.i.j
      End
    sb.i=b.i
    End
  Say 'The equations are:'
  do i = 1 to n;
    ol=''
    Do j=1 To n
      ol=ol format(a.i.j,4,4)
      End
    ol=ol'  'format(b.i,4,4)
    Say ol
    end

  call Gauss_elimination

  call Backward_substitution

  Say 'Solutions:'
  Do i=1 To n
    Say 'x('i')='||x.i
    End

  /* Check solutions: */
  Say 'Residuals:'
  do i = 1 to n
    res=0
    Do j=1 To n
      res=res+(sa.i.j*x.j)
      End
    res=res-sb.i
    Say 'res('i')='res
    End

Exit

Gauss_elimination:
  do j = 1 to n
     do i = j+1 to n /* For each of the rows beneath the current (pivot) row. */
        t = a.j.j / a.i.j
        do k = j+1 to n /* Subtract a multiple of row i from row j. */
           a.i.k = a.j.k - t*a.i.k
        end
        b.i = b.j - t*b.i /* ... and the right-hand side. */
     end
  end
  Return

Backward_substitution:
  x.n = b.n / a.n.n
  do j = n-1 to 1 by -1
     t = 0
     do i = j+1 to n
        t = t + a.j.i*x.i
     end
     x.j = (b.j - t) / a.j.j
  end
  Return
