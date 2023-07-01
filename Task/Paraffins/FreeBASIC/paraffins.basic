' version 31-12-2016
' compile with: fbc -s console
' uses gmp, translation from pascal

#Include Once "gmp.bi"

Const As Integer max_n = 500, branch = 4

Dim Shared As mpz_ptr rooted(), unrooted(), c()
Dim Shared As mpz_ptr cnt, tmp

Sub tree(br As UInteger, n As UInteger, l As UInteger, sum As UInteger, cnt As mpz_ptr)

  Dim As UInteger b, m

  For b = br +1 To branch
    sum = sum + n
    If sum > max_n Then Return

    ' prevent unneeded long math
    If (l * 2 >= sum) And (b >= branch) Then Return

    If b = (br +1) Then
      mpz_mul(c(br), rooted(n), cnt)
    Else
      mpz_add_ui(tmp, rooted(n), b - br -1)
      mpz_mul(c(br), c(br), tmp)
      mpz_divexact_ui(c(br), c(br), b - br)
    End If

    If l * 2 < sum Then
      mpz_add(unrooted(sum), unrooted(sum), c(br))
    End If
    If b < branch Then
      mpz_add(rooted(sum), rooted(sum), c(br))
      For m = n -1 To 1 Step -1
        tree(b, m, l, sum, c(br))
      Next
    End If
  Next

End Sub

Sub bicenter(s As UInteger)
  If (s And 1) = 1 Then Return
  mpz_add_ui(tmp, rooted(s \ 2), 1)
  mpz_mul(tmp, rooted(s \ 2), tmp)
  mpz_tdiv_q_2exp(tmp, tmp, 1)
  mpz_add(unrooted(s), unrooted(s), tmp)
End Sub

' ------=< MAIN >=------

Dim As UInteger n, sum
Dim As ZString Ptr ans

ReDim rooted(max_n), unrooted(max_n)
For n = 0 To max_n
    rooted(n) = Allocate(Len(__mpz_struct)) : Mpz_init(  rooted(n))
  unrooted(n) = Allocate(Len(__mpz_struct)) : Mpz_init(unrooted(n))
Next
For n = 0 To 1
  mpz_set_ui(  rooted(n), 1)
  mpz_set_ui(unrooted(n), 1)
Next

ReDim c(branch -1)
For n = 0 To branch -1
  c(n) = Allocate(Len(__mpz_struct)) : Mpz_init(c(n))
Next

cnt = Allocate(Len(__mpz_struct)) : Mpz_init_set_ui(cnt, 1)
tmp = Allocate(Len(__mpz_struct)) : Mpz_init(tmp)

sum = 1
For n = 1 To max_n
  tree(0, n, n, sum, cnt)
  bicenter(n)
  'gmp_printf("%d: %Zd"+Chr(13)+Chr(10), n, unrooted(n))
  ans = Mpz_get_str (0, 10, unrooted(n))
  Print Using "###: "; n; : Print *ans
Next

For n = 0 To max_n
  mpz_Clear(  rooted(n))
  mpz_Clear(unrooted(n))
Next

For n = 0 To branch -1
  mpz_clear(c(n))
Next

mpz_clear(cnt)
mpz_clear(tmp)

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
