' Last letter-first letter - VBScript - 11/03/2019
    names = array( _
        "audino", "bagon", "baltoy", "banette", _
        "bidoof", "braviary", "bronzor", "carracosta", "charmeleon", _
        "cresselia", "croagunk", "darmanitan", "deino", "emboar", _
        "emolga", "exeggcute", "gabite", "girafarig", "gulpin", _
        "haxorus", "heatmor", "heatran", "ivysaur", "jellicent", _
        "jumpluff", "kangaskhan", "kricketune", "landorus", "ledyba", _
        "loudred", "lumineon", "lunatone", "machamp", "magnezone", _
        "mamoswine", "nosepass", "petilil", "pidgeotto", "pikachu", _
        "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz", _
        "registeel", "relicanth", "remoraid", "rufflet", "sableye", _
        "scolipede", "scrafty", "seaking", "sealeo", "silcoon", _
        "simisear", "snivy", "snorlax", "spoink", "starly", "tirtouga", _
        "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix", _
        "wailord", "wartortle", "whismur", "wingull", "yamask")

    maxPathLength = 0
    maxPathLengthCount = 0
    maxPathExample = ""
    t1=timer

    For i = 0 To ubound(names)
        'swap names(0), names(i)
        temp=names(0): names(0)=names(i): names(i)=temp
        Call lastfirst(names, 1)
        'swap names(0), names(i)
        temp=names(0): names(0)=names(i): names(i)=temp
    Next 'i
    buf = buf & "Maximum length = " & maxPathLength & vbCrLf
    buf = buf & "Number of solutions with that length = " & maxPathLengthCount & vbCrLf
    buf = buf & "One such solution: "  & vbCrLf & maxPathExample & vbCrLf
    t2=timer
    MsgBox buf,,"Last letter-first letter - " & Int(t2-t1) & " sec"

Sub lastfirst(names, offset)
    dim i, l
    If offset > maxPathLength Then
        maxPathLength = offset
        maxPathLengthCount = 1
    ElseIf offset = maxPathLength Then
        maxPathLengthCount = maxPathLengthCount + 1
        maxPathExample = ""
        For i = 0 To offset-1
            maxPathExample = maxPathExample & names(i) & vbCrLf
        Next 'i
    End If
    l = Right(names(offset - 1),1)
    For i = offset To ubound(names)
        If Left(names(i),1) = l Then
            'swap names(i), names(offset)
            temp=names(offset): names(offset)=names(i): names(i)=temp
            Call lastfirst(names, offset+1)
            'swap names(i), names(offset)
            temp=names(offset): names(offset)=names(i): names(i)=temp
        End If
    Next 'i
End Sub 'lastfirst
