/* REXX */
parse version version; say version 'Intel i7 5GHz'
say 'Radicals for an integer = product of distinct prime factors'
say 'Version 1: tailor-made procedures'
say
call setp
Numeric Digits 100
/* 1. Radicals from 1 to 50 */
Say 'Radicals of 1..50:'
ol=''
Do n=1 To 50
  ol=ol||right(rad(n),5)
  If n//10=0 then Do
    Say ol
    ol=''
    End
  End

Say ''
Call radt 99999
Call radt 499999
Call radt 999999

Say ''
Say 'Distribution of radicals:'
Call time 'R'
cnt.=0
Do v=1 To 1000000
  If v//100000=1 Then Do
    ti=v%100000
    etime.ti=format(time('E'),4,1)
    End
  p=rad(v,'cnt')
  cnt.p+=1
  /**************************************
  If p=7 Then
    Say v':' rad(v,'lstx') '=' rad(v)
  **************************************/
  End
etime.10=format(time('E'),4,1)
Do d=0 To 20
  If cnt.d>0 Then
    Say d':' right(cnt.d,8)
  End
Say ''
Say 'Timings:'
Do ti=1 To 10
  Say right(ti,2) etime.ti 'seconds'
  End
Exit

radt:
  Parse Arg u
  Say 'The radical of' u 'is' rad(u)'.'
  Return

rad:
  Parse Arg z,what
  zz=z
  plist=''
  exp.=0
  Do Until p*p>z
    Do pi=1 By 1 Until p*p>z
      p=word(primzahlen,pi)
      exp.p=0
      Do while z//p=0
        exp.p+=1
        If pos(p,plist)=0 Then
          plist=plist p
        z=z%p
        End
      End
    End
  exp.z+=1
  If pos(z,plist)=0 &z<>1 Then
    plist=plist z
  Select
    When what='lst' Then
      Return plist
    When what='lstx' Then Do
      s=''
      Do While plist<>''
        Parse Var plist p plist
        if exp.p=1 Then
          s=s'*'p
        Else
          s=s'*'p'**'exp.p
        End
      Return strip(s,,'*')
      End
    When what='cnt' Then
      Return words(plist)
    Otherwise Do
      rad=1
      Do while plist>''
        Parse Var plist p plist
        rad=rad*p
        End
      Return rad
      End
    End

setp:
primzahlen=,
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101,
103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197,
199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311,
313 317 331 337 347 349 353 359 367 373 379 383 389 397 401 409 419 421 431,
433 439 443 449 457 461 463 467 479 487 491 499 503 509 521 523 541 547 557,
563 569 571 577 587 593 599 601 607 613 617 619 631 641 643 647 653 659 661,
673 677 683 691 701 709 719 727 733 739 743 751 757 761 769 773 787 797 809,
811 821 823 827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937,
941 947 953 967 971 977 983 991 997 1009 1013 1019 1021 1031 1033 1039 1049
Return
