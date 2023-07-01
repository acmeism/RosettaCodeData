' version 13-09-2015
' compile with: fbc -s console

' iteration limit
#Define max_it 500
' the highest number to be tested
#Define max_number_to_test 10000

Dim As String num, rev
Dim As String temp(), store()

Dim As Integer x, x1, palindrome
Dim As UInteger it, s, carry, sum, match, seed, related
Dim As UInteger num2test, p_count, lychrel_palindrome()

For num2test = 1 To max_number_to_test
    num = Str(num2test)
    rev = num : s = Len(num) - 1
    For x = 0 To s
        rev[s - x] = num[x]
    Next
    ' if num = rev then palindrome = -1 else palindrome = 0
    ' palindrome is set to the result of the compare of num and rev
    palindrome = (num = rev)
    it = 0
    ReDim temp(1 To max_it)
    Do
        carry = 0
        For x = s To 0 Step -1 'add the two numbers
            sum = num[x] + rev[x] + carry
            If sum > (9 + 48 + 48) Then
                num[x] = sum - 10 - 48
                carry = 1
            Else
                num[x] = sum - 48
                carry = 0
            End If
        Next
        If carry = 1 Then num = "1" + num
        it = it + 1 : temp(it) = num
        rev = num : s = Len(num) - 1
        For x = 0 To s
            rev[s - x] = num[x]
        Next
    Loop Until num = rev OrElse it = max_it
    If it = max_it Then
        match = 0
        ' if it's palindrome then save the number
        If palindrome <> 0 Then
            p_count = p_count + 1
            ReDim Preserve lychrel_palindrome(1 To p_count)
            lychrel_palindrome(p_count) = num2test
        End If
        For x = 1 To seed ' check against previous found seed(s)
            For x1 = max_it To 1 Step -1
                If store(x, 1) = temp(x1) Then
                    match = 1
                    related = related + 1
                    Exit For, For
                Else
                    If Len(store(x,1)) > Len(temp(x1)) Then
                        Exit For
                    End If
                End If
            Next
        Next
        ' no match found then it's a new seed, store it
        If match = 0 Then
            seed = seed + 1
            ReDim Preserve store(seed, 1)
            store(seed, 0) = Str(num2test)
            store(seed, 1) = temp(max_it)
        End If
    End If
Next

Print
Print "                      Testing numbers: 1 to "; Str(max_number_to_test)
Print "                    Iteration maximum: ";Str(max_it)
Print
Print "              Number of Lychrel seeds: "; seed
Print "                       Lychrel number: ";
For x = 1 To seed : Print store(x,0); " "; : Next : Print
Print "             Number of relateds found: "; related
Print " Lychrel numbers that are palindromes: "; p_count
Print "                  Lychrel palindromes: ";
For x = 1 To p_count : Print lychrel_palindrome(x); " "; : Next : Print
Print

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
