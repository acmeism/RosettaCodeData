"US0378331005","US0373831005","US0337833103","AU0000XVGZA3","AU0000VXGZA3","FR0000988040" | ForEach-Object {
    [PSCustomObject]@{
        ISIN    = $_
        IsValid = Test-ISIN -Number $_
    }
}
