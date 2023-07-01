    Function Range(ParamArray ranges As Integer()()) As IEnumerable(Of Integer)
        Return ranges.SelectMany(Function(r) Range(r(0), r(1), If(r.Length < 3, 1, r(2))))
    End Function
