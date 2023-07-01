    Module Extensions
        <Extension()>
        Function ToHashSet(Of T)(ByVal src As IEnumerable(Of T), ByVal Optional _
                                 IECmp As IEqualityComparer(Of T) = Nothing) As HashSet(Of T)
            Return New HashSet(Of T)(src, IECmp)
        End Function
    End Module
