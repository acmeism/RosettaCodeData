#Create generator of extended fibonaci
Function Get-ExtendedFibonaciGenerator($InitialValues ){
    $Values = $InitialValues
    {
        #exhaust initial values first before calculating next values by summation
        if ($InitialValues.Length -gt 0) {
            $NextValue = $InitialValues[0]
            $Script:InitialValues = $InitialValues | Select -Skip 1
            return $NextValue
        }

        $NextValue = $Values | Measure-Object -Sum | Select -ExpandProperty Sum
        $Script:Values = @($Values | Select-Object -Skip 1) + @($NextValue)

        $NextValue
    }.GetNewClosure()
}
