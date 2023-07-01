' Convert tower block data into a string representation, then manipulate that.
Module Module1
    Sub Main(Args() As String)
        Dim shoTow As Boolean = Environment.GetCommandLineArgs().Count > 1  ' Show towers.
        Dim wta As Integer()() = {                       ' Water tower array (input data).
            New Integer() {1, 5, 3, 7, 2}, New Integer() {5, 3, 7, 2, 6, 4, 5, 9, 1, 2},
            New Integer() {2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1},
            New Integer() {5, 5, 5, 5}, New Integer() {5, 6, 7, 8},
            New Integer() {8, 7, 7, 6}, New Integer() {6, 7, 10, 7, 6}}
        Dim blk As String,                   ' String representation of a block of towers.
            lf As String = vbLf,      ' Line feed to separate floors in a block of towers.
            tb = "██", wr = "≈≈", mt = "  "    ' Tower Block, Water Retained, eMpTy space.
        For i As Integer = 0 To wta.Length - 1
            Dim bpf As Integer                    ' Count of tower blocks found per floor.
            blk = ""
            Do
                bpf = 0 : Dim floor As String = ""  ' String representation of each floor.
                For j As Integer = 0 To wta(i).Length - 1
                    If wta(i)(j) > 0 Then      ' Tower block detected, add block to floor,
                        floor &= tb : wta(i)(j) -= 1 : bpf += 1    '  reduce tower by one.
                    Else  '      Empty space detected, fill when not first or last column.
                        floor &= If(j > 0 AndAlso j < wta(i).Length - 1, wr, mt)
                    End If
                Next
                If bpf > 0 Then blk = floor & lf & blk ' Add floors until blocks are gone.
            Loop Until bpf = 0                       ' No tower blocks left, so terminate.
            ' Erode potential water retention cells from left and right.
            While blk.Contains(mt & wr) : blk = blk.Replace(mt & wr, mt & mt) : End While
            While blk.Contains(wr & mt) : blk = blk.Replace(wr & mt, mt & mt) : End While
            ' Optionaly show towers w/ water marks.
            If shoTow Then Console.Write("{0}{1}", lf, blk)
            ' Subtract the amount of non-water mark characters from the total char amount.
            Console.Write("Block {0} retains {1,2} water units.{2}", i + 1,
                                     (blk.Length - blk.Replace(wr, "").Length) \ 2, lf)
        Next
    End Sub
End Module
