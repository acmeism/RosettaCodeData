Option Explicit
'----------------------------------------------------------------------
Private Function coin_count(coins As Variant, amount As Long) As Variant
'return type will be Decimal
Dim s() As Variant
Dim n As Long, c As Long

  ReDim s(amount + 1)
  s(1) = CDec(1)
  For c = LBound(coins) To UBound(coins)
    For n = coins(c) To amount
      s(n + 1) = CDec(s(n + 1) + s(n - coins(c) + 1))
    Next n
  Next c
  coin_count = s(amount + 1)
End Function
'----------------------------------------------------------------------
Sub Main()
Dim us_common_coins As Variant
Dim us_coins As Variant

  'The next line creates 0-based array
  us_common_coins = Array(25, 10, 5, 1)
  Debug.Print coin_count(us_common_coins, 100)

  us_coins = Array(100, 50, 25, 10, 5, 1)
  Debug.Print coin_count(us_coins, 100000)

End Sub
