    Function Range(ParamArray ranges() As (start As Integer, [stop] As Integer, [step] As Integer)) As IEnumerable(Of Integer)
        ' Note: SelectMany is equivalent to bind, flatMap, etc.
        Return ranges.SelectMany(Function(r) Range(r.start, r.stop, r.step))
    End Function
