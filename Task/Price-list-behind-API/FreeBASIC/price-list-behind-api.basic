Randomize Timer

' Sample price generation
Dim Shared As Integer price_list_size
price_list_size = Int(Rnd * 2000) + 99000
Dim Shared  As Integer price_list(price_list_size)
For i As Integer = 0 To price_list_size - 1
    price_list(i) = Int(Rnd * 100000)
Next i

Dim Shared As Integer delta_price
delta_price = 1     ' Minimum difference between any two different prices

' API
Function get_prange_count(Byval startp As Integer, Byval endp As Integer) As Integer
    Dim count As Integer = 0
    For i As Integer = 0 To price_list_size - 1
        If price_list(i) >= startp And price_list(i) <= endp Then count += 1
    Next i
    Return count
End Function

Function get_max_price() As Integer
    Dim max_price As Integer = price_list(0)
    For i As Integer = 1 To price_list_size - 1
        If price_list(i) > max_price Then max_price = price_list(i)
    Next i
    Return max_price
End Function

' Solution
Sub get_5k(Byval mn As Integer, Byval mx As Integer, Byval num As Integer, Byref ret_mx As Integer, Byref ret_count As Integer)
    Dim As Integer count = get_prange_count(mn, mx)
    Dim As Integer delta_mx = (mx - mn) / 2
    While count <> num And delta_mx >= delta_price / 2
        If count > num Then
            mx -= delta_mx
        Else
            mx += delta_mx
        End If
        mx = mx \ 1    ' Floor
        count = get_prange_count(mn, mx)
        delta_mx /= 2
    Wend
    ret_mx = mx
    ret_count = count
End Sub

Sub get_all_5k(Byval mn As Integer, Byval mx As Integer, Byval num As Integer, result() As Integer)
    Dim As Integer partmax, partcount
    get_5k(mn, mx, num, partmax, partcount)
    Redim As Integer result(2)
    result(0) = mn
    result(1) = partmax
    result(2) = partcount
    While partmax < mx
        Dim As Integer partmin = partmax + delta_price
        get_5k(partmin, mx, num, partmax, partcount)
        Redim Preserve result(0 To Ubound(result, 1) + 3) As Integer
        result(Ubound(result, 1) - 2) = partmin
        result(Ubound(result, 1) - 1) = partmax
        result(Ubound(result, 1)) = partcount
    Wend
End Sub

Print "Using"; price_list_size; " random prices from 0 to"; get_max_price()
Dim As Integer result()
get_all_5k(0, get_max_price(), 5000, result())
Print "Splits into"; Ubound(result, 1) \ 3; " bins of approx 5000 elements"
For i As Integer = 0 To Ubound(result, 1) Step 3
    Print Using "  From ######.# ... ######.# with #### items."; result(i); result(i + 1); result(i + 2)
Next i

Dim As Integer total_count = 0
For i As Integer = 2 To Ubound(result, 1) Step 3
    total_count += result(i)
Next i
If price_list_size <> total_count Then Print !"\nWhoops! Some items missing:"

Sleep
