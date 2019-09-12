Private Function coin_count(coins As Variant, amount As Long) As Variant 'return type will be Decimal
    'sequence s = Repeat(0, amount + 1)
    Dim s As Variant
    ReDim s(amount + 1)
    Dim c As Integer
    s(1) = CDec(1)
    For c = 1 To UBound(coins)
        For n = coins(c) To amount
            s(n + 1) = CDec(s(n + 1) + s(n - coins(c) + 1))
        Next n
    Next c
    coin_count = s(amount + 1)
End Function
Public Sub main2()
    Dim us_commons_coins As Variant
    'The next line creates a base 1 array
    us_common_coins = [{25, 10, 5, 1}]
    Debug.Print coin_count(us_common_coins, 100)
    Dim us_coins As Variant
    us_coins = [{100,50,25, 10, 5, 1}]
    Debug.Print coin_count(us_coins, 100000)
End Sub
