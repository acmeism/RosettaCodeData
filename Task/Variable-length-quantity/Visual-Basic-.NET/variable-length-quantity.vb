Module Module1

    Function ToVlq(v As ULong) As ULong
        Dim array(8) As Byte
        Dim buffer = ToVlqCollection(v).SkipWhile(Function(b) b = 0).Reverse().ToArray
        buffer.CopyTo(array, 0)
        Return BitConverter.ToUInt64(array, 0)
    End Function

    Function FromVlq(v As ULong) As ULong
        Dim collection = BitConverter.GetBytes(v).Reverse()
        Return FromVlqCollection(collection)
    End Function

    Iterator Function ToVlqCollection(v As ULong) As IEnumerable(Of Byte)
        If v > Math.Pow(2, 56) Then
            Throw New OverflowException("Integer exceeds max value.")
        End If

        Dim index = 7
        Dim significantBitReached = False
        Dim mask = &H7FUL << (index * 7)
        While index >= 0
            Dim buffer = mask And v
            If buffer > 0 OrElse significantBitReached Then
                significantBitReached = True
                buffer >>= index * 7
                If index > 0 Then
                    buffer = buffer Or &H80
                End If
                Yield buffer
            End If
            mask >>= 7
            index -= 1
        End While
    End Function

    Function FromVlqCollection(vlq As IEnumerable(Of Byte)) As ULong
        Dim v = 0UL
        Dim significantBitReached = False

        Using enumerator = vlq.GetEnumerator
            Dim index = 0
            While enumerator.MoveNext
                Dim buffer = enumerator.Current
                If buffer > 0 OrElse significantBitReached Then
                    significantBitReached = True
                    v <<= 7
                    v = v Or (buffer And &H7FUL)
                End If

                index += 1
                If index = 8 OrElse (significantBitReached AndAlso (buffer And &H80) <> &H80) Then
                    Exit While
                End If
            End While
        End Using

        Return v
    End Function

    Sub Main()
        Dim values = {&H7FUL << 7 * 7, &H80, &H2000, &H3FFF, &H4000, &H200000, &H1FFFFF}
        For Each original In values
            Console.WriteLine("Original: 0x{0:X}", original)

            REM collection
            Dim seq = ToVlqCollection(original)
            Console.WriteLine("Sequence: 0x{0}", seq.Select(Function(b) b.ToString("X2")).Aggregate(Function(a, b) String.Concat(a, b)))

            Dim decoded = FromVlqCollection(seq)
            Console.WriteLine("Decoded: 0x{0:X}", decoded)

            REM ints
            Dim encoded = ToVlq(original)
            Console.WriteLine("Encoded: 0x{0:X}", encoded)

            decoded = FromVlq(encoded)
            Console.WriteLine("Decoded: 0x{0:X}", decoded)

            Console.WriteLine()
        Next
    End Sub

End Module
