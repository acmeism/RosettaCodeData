        For r = 0 To ROWS - 1
            For c = 0 To COLS - 1
                Dim val = nums(r, c)
                Console.WriteLine(val)
                If val = 20 Then GoTo BREAK
            Next
        Next
        BREAK:
