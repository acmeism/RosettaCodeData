/*REXX*/
    Parse Arg fn
    Parse Var fn ou'.'
    maxpn = 10000               /* maximum possibilities to check through */
    output = ou'.out.txt'
 /* read row/col values into rowpp. and colpp. arrays */
    cc = linein(fn)
    rows = words(cc)
    dd = linein(fn)
    cols = words(dd)
    char = '0ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijk'
    cntr = 0
    Do i = 1 To rows
       rowpp.i = CV(cc,i)
       cntr = cntr + sum
    End
    cntc = 0
    Do i = 1 To cols
       colpp.i = CV(dd,i)
       cntc = cntc + sum
    End
    If (cntr <> cntc)|(cntr = 0) Then Do
       Say 'error Sum of rows <> sum of cols'
       Exit 999
    End
    Say cntr 'colored cells'
    ar = copies('-',rows*cols)
 /* values are -=unknown .=blank @=Color */
 /* PREFILL  array */
    'erase' output
 /**********COL PREFILL ************/
    Do col = 1 To cols
       r = colpp.col
       Parse Var r z r
       Do While r <> ''
          Parse Var r q r
          z = z + q + 1
       End
       result = copies('-',rows)
       If z = rows Then result = FILL_LINE(colpp.col)
       Else If z = 0 Then result = copies('.',rows)
       Do row = 1 To rows
          ar = overlay(substr(result,row,1),ar,(row-1)*cols+col)
       End
    End
 /**********ROW PREFILL ************/
    Do row = 1 To rows
       c = rowpp.row
       Parse Var c t c
       Do While c <> ''
          Parse Var c q c
          t = t + q + 1
       End
       result = substr(ar,(row-1)*cols+1,cols)
       If t = cols Then result = left(FILL_LINE(rowpp.row),cols)
       Else If t = 0 Then result = copies('.',cols)
       ar = overlay(result,ar,(row-1)*cols+1)
    End
 /********** ok here we loop ************/
    cnttry = 1
    nexttry = 2
    next.cnttry = ar
    sol = 0
    Do label nextpos While cnttry < nexttry
       Say 'trying' cnttry 'of' nexttry-1
       ar = next.cnttry
       cnttry = cnttry + 1
       Do Until sar = ar
          sar = ar
          Do row = 1 To rows
             /**********process rows ************/
             rowcol = substr(ar,(row-1)*cols+1,cols)
             pp = rowpp.row
             If PROCESSROW() Then Iterate nextpos
             Else ar = overlay(left(rowcol,cols),ar,(row-1)*cols+1)
          End
          Do col = 1 To cols
             rowcol = ''
             Do row = 1 To rows
                rowcol = rowcol || substr(ar,(row-1)*cols+ col,1)
             End
             pp = colpp.col
             If PROCESSROW() Then Iterate nextpos
             Do row = 1 To rows
                ar = overlay(substr(rowcol,row,1),ar,(row-1)*cols + col)
             End
          End
          If pos('-',ar) = 0 Then Do       /* hurray we have a solution */
             /* at this point we need to verify solution */
             If CHECKBOARD() Then Iterate nextpos   /* too bad didn't match */
             sol = sol + 1
             Call LINEOUT output,'This is solution no:' sol
             Call DUMPBOARD
             Iterate nextpos
          End
          If sar = ar Then Do
             fnd = pos('-',ar)
             next.nexttry = overlay('.',ar,fnd)
             nexttry = nexttry + 1
             ar = overlay('@',ar,fnd)
          End
       End
    End nextpos
    If sol = 0 Then sol = 'No'
    Say sol 'solutions found'
    Exit

 CHECKBOARD:
    Do row = 1 To rows
      /**********process rows ************/
       rowcol = substr(ar,(row-1)*cols+1,cols)
       pp = rowpp.row
       If CHECKROW() Then Return 1
    End
    Do col = 1 To cols
       rowcol = ''
       Do row = 1 To rows
          rowcol = rowcol || substr(ar,(row-1)*cols+ col,1)
       End
       pp = colpp.col
       If CHECKROW() Then Return 1
    End
    Return 0                                               /* we did it */

 CHECKROW:
    len_item = length(rowcol)
    st = 1
    If pp = 0 Then Return rowcol <> copies('.',len_item)
    Else If pp = len_item Then Return rowcol <> copies('@',len_item)
    Do While (pp <> '') & (st <= len_item)
       Parse Var pp p1 pp
       of = pos('@',rowcol'@',st)
       If of > len_item Then Return 1
       If substr(rowcol,of,p1) <> copies('@',p1) Then Return 1
       st = of + p1
       If substr(rowcol'.',st,1) <> '.' Then Return 1
    End
    Return 0


 DUMPBOARD:
    Parse Arg qr
    p = '..'
    q = '..'
    Do i = 1 To cols
       n = right(i,2)
       p = p left(n,1)
       q = q right(n,1)
    End
    Call LINEOUT output, p
    Call LINEOUT output, q
    Do i = 1 To rows
       o = right(i,2)
       p = substr(ar,(i-1)*cols+1,cols)
       Do j = 1 To cols
          Parse Var p z +1 p
          o = o z
       End
       Call LINEOUT output, o
    End
    Return

 FILL_LINE:
    Parse Arg items
    oo = ''
    Do While items <> ''
       Parse Var items a items
       oo = oo||copies('@',a)'.'
    End
    Return oo

 CV:
    Parse Arg cnts, rwcl
    str = word(cnts,rwcl)
    ret = ''
    sum = 0
    Do k = 1 To length(str)
       this = pos(substr(str,k,1),char)-1
       ret = ret this
       sum = sum + this
    End
    Return space(ret)

 PROCESSROW:                           /* rowcol pp in, rowcol pp of ol */
    prerow = rowcol
    len_item = length(rowcol)
    If pos('-',rowcol) = 0 Then Do
       pp = ''
       Return 0
    End
    of = 1
    kcnt = 0
    /* reduce the left side with already populated values */
    Do While (of < len_item) & (pp <> '')
       kcnt = kcnt + 1
       If kcnt > len_item Then Return 1
       If substr(rowcol,of,1) = '.' Then Do
          k = verify(substr(rowcol,of)'%','.')
          of = of + k - 1
          Iterate
       End
       nl = word(pp,1)
       len = verify(substr(rowcol,of)'%','-@') - 1
       If len < nl Then Do
          rowcol = overlay(copies('.',len),rowcol,of)
          of = of + len
          Iterate
       End
       If (len = nl) & (pos('@',substr(rowcol,of,nl))>0) Then Do
          rowcol = overlay(copies('@',nl),rowcol,of)
          of = of + nl
          pp = subword(pp,2)
          Iterate
       End
       If substr(rowcol,of,1) = '@' Then Do
          rowcol = overlay(copies('@',nl)'.',rowcol,of)
          of = of + nl
          pp = subword(pp,2)
          Iterate
       End
       Leave
    End
    /* reduce the right side with already populated values */
    ofm = len_item + 1 - of
    ol = 1
    kcnt = 0
    Do While (ol < ofm) & (pp <> '')
       kcnt = kcnt + 1
       If kcnt > len_item Then Return 1
       revrow = reverse(rowcol)
       If substr(revrow,ol,1) = '.' Then Do
          k = verify(substr(revrow,ol)'%','.')
          ol = ol + k - 1
          Iterate
       End
       nl = word(pp,words(pp))
       len = verify(substr(revrow,ol)'%','-@') - 1
       If len < nl Then Do
          rowcol = overlay(copies('.',len),rowcol,len_item-ol-len+2)
          ol = ol + len
          Iterate
       End
       If (len = nl) & (pos('@',substr(revrow,ol,nl))>0) Then Do
          rowcol = overlay(copies('@',nl),rowcol,len_item-ol-nl+2)
          ol = ol + nl
          pp = subword(pp,1,words(pp)-1)
          Iterate
       End
       If substr(revrow,ol,1) = '@' Then Do
          rowcol = overlay('.'copies('@',nl),rowcol,len_item-ol-nl+1)
          ol = ol + nl
          pp = subword(pp,1,words(pp)-1)
          Iterate
       End
       Leave
    End
    If pp = 0 Then pp = ''
    If pp = '' Then rowcol = changestr('-',rowcol,'.')
    If pp <> '' Then Do
       lv = len_item-of-ol+2
       pos. = ''
       pn = 0
       pi = substr(rowcol,of,lv)
       If (copies('-',length(pi)) = pi) Then Do
          len = CNT(pp)
          If (len + mx) <= lv Then Do
             Return 0
          End
       End
       /* oh oh need to check for posibilities */
       Call TRY '',pp
       If pn > maxpn Then Do
          over = over + 1
          Return 0
       End
       fnd = 0
       fu = pos.1
       Do z = 2 To pn
          Do j = 1 To lv
             If substr(fu,j,1) <> substr(pos.z,j,1) Then fu = overlay('-',fu,j)
          End
       End
       Do z = 1 To lv
          If substr(fu,z,1) <> '-' Then rowcol = overlay(substr(fu,z,1),rowcol,of+z-1)
       End
    End
    Return 0
 TRY: Procedure Expose pn pos. maxpn lv pi
    Parse Arg prev,pp
    If pp = '' Then Do
       rem = substr(pi,length(prev)+1)
       If translate(rem,'..','.-') <> copies('.',length(rem)) Then Return
       prev = left(prev||copies('.',lv),lv)
       pn = pn + 1
       If pn > maxpn Then Return
       pos.pn = prev
       Return
    End
    Parse Var pp p1 pp
    If length(prev)+p1 > lv Then Return
    Do i = 0 To lv - length(prev)-p1
       If translate(substr(pi,length(prev)+1,i),'..','.-') = copies('.',i) Then
         If translate(substr(pi,length(prev)+i+1,p1),'@@','@-') = copies('@',p1) Then
           If substr(pi,length(prev)+i+p1+1,1) <> '@' Then
             Call TRY prev||copies('.',i)||copies('@',p1)'.',pp
    End
    Return
 CNT: Procedure Expose mx
    Parse Arg len items
    mx = len
    Do While items <> ''
       Parse Var items ii items
       len = len + ii + 1
       If ii > mx Then mx = ii
    End
    Return len
