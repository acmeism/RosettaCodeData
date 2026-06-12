Function countdown(target As Integer, numbers() As Integer) As Boolean
    Dim As Integer i, k, j, l, m
    If Ubound(numbers) = 0 Then Return False
    For i = 0 To Ubound(numbers)
        Dim nums1(Ubound(numbers) - 1) As Integer
        For k = 0 To Ubound(numbers) - 1
            nums1(k) = Iif(k < i, numbers(k), numbers(k + 1))
        Next k
        For j = 0 To Ubound(nums1)
            Dim nums2(Ubound(nums1) - 1) As Integer
            For l = 0 To Ubound(nums1) - 1
                nums2(l) = Iif(l < j, nums1(l), nums1(l + 1))
            Next l
            If nums1(j) >= numbers(i) Then
                Dim res As Integer = nums1(j) + numbers(i)
                Dim numsNew(Ubound(nums2) + 1) As Integer
                For m = 0 To Ubound(nums2)
                    numsNew(m) = nums2(m)
                Next m
                numsNew(Ubound(numsNew)) = res
                If res = target Orelse countdown(target, numsNew()) Then
                    Print res; " ="; nums1(j); " +"; numbers(i)
                    Return True
                End If
                If numbers(i) <> 1 Then
                    res = nums1(j) * numbers(i)
                    For m = 0 To Ubound(nums2)
                        numsNew(m) = nums2(m)
                    Next m
                    numsNew(Ubound(numsNew)) = res
                    If res = target Orelse countdown(target, numsNew()) Then
                        Print res; " ="; nums1(j); " *"; numbers(i)
                        Return True
                    End If
                End If
                If nums1(j) <> numbers(i) Then
                    res = nums1(j) - numbers(i)
                    For m = 0 To Ubound(nums2)
                        numsNew(m) = nums2(m)
                    Next m
                    numsNew(Ubound(numsNew)) = res
                    If res = target Or countdown(target, numsNew()) Then
                        Print res; " ="; nums1(j); " -"; numbers(i)
                        Return True
                    End If
                End If
                If numbers(i) <> 1 Andalso nums1(j) Mod numbers(i) = 0 Then
                    res = nums1(j) \ numbers(i)
                    For m = 0 To Ubound(nums2)
                        numsNew(m) = nums2(m)
                    Next m
                    numsNew(Ubound(numsNew)) = res
                    If res = target Orelse countdown(target, numsNew()) Then
                        Print res; " ="; nums1(j); " /"; numbers(i)
                        Return True
                    End If
                End If
            End If
        Next j
    Next i
    Return False
End Function

Dim allNumbers(23) As Integer = {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100}
Dim numbersList(3, 5) As Integer = {{3, 6, 25, 50, 75, 100}, {100, 75, 50, 25, 6, 3}, {8, 4, 4, 6, 8, 9}}
Dim targetList(3) As Integer = {952, 952, 594}

Randomize Timer
Dim As Integer i, j
For i = 0 To 5
    numbersList(3, i) = allNumbers(Int(Rnd * Ubound(allNumbers)))
Next i
targetList(3) = Int(Rnd * 900) + 101

For i = 0 To 3
    Print "Using : [";
    Dim currentNumbers(5) As Integer
    For j = 0 To 5
        currentNumbers(j) = numbersList(i, j)
        Print currentNumbers(j); ",";
    Next j
    Print Chr(8); " ]"
    Print "Target:"; targetList(i)
    Dim start As Double = Timer
    Dim done As Boolean = countdown(targetList(i), currentNumbers())
    Print "Took"; Int((Timer - start) * 1000); " ms"
    If Not done Then Print "No exact solution found"
    Print
Next i

Sleep
