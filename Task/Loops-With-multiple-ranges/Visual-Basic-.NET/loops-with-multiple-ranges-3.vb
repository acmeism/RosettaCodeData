    <Runtime.CompilerServices.Extension>
    Function ConcatRange(source As IEnumerable(Of Integer), start As Integer, [stop] As Integer, Optional [step] As Integer = 1) As IEnumerable(Of Integer)
        Return source.Concat(Range(start, [stop], [step]))
    End Function
