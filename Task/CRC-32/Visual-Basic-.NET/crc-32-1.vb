Public Class Crc32

    ' Table for pre-calculated values.
    Shared table(255) As UInteger

    ' Initialize table
    Shared Sub New()
        For i As UInteger = 0 To table.Length - 1
            Dim te As UInteger = i ' table entry
            For j As Integer = 0 To 7
                If (te And 1) = 1 Then te = (te >> 1) Xor &HEDB88320UI Else te >>= 1
            Next
            table(i) = te
        Next
    End Sub

    ' Return checksum calculation for Byte Array,
    '  optionally resuming (used when breaking a large file into read-buffer-sized blocks).
    ' Call with Init = False to continue calculation.
    Public Shared Function cs(BA As Byte(), Optional Init As Boolean = True) As UInteger
        Static crc As UInteger
        If Init Then crc = UInteger.MaxValue
        For Each b In BA
            crc = (crc >> 8) Xor table((crc And &HFF) Xor b)
        Next
        Return Not crc
    End Function

End Class
