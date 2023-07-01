Function FFT($Arr){
    $Len = $Arr.Count

    If($Len -le 1){Return $Arr}

    $Len_Over_2 = [Math]::Floor(($Len/2))

    $Output  = New-Object System.Numerics.Complex[] $Len

    $EvenArr = @()
    $OddArr  = @()

    For($i = 0; $i -lt $Len; $i++){
        If($i % 2){
            $OddArr+=$Arr[$i]
        }Else{
            $EvenArr+=$Arr[$i]
        }
    }

    $Even = FFT($EvenArr)
    $Odd  = FFT($OddArr)

    For($i = 0; $i -lt $Len_Over_2; $i++){
        $Twiddle = [System.Numerics.Complex]::Exp([System.Numerics.Complex]::ImaginaryOne*[Math]::Pi*($i*-2/$Len))*$Odd[$i]

        $Output[$i]             = $Even[$i] + $Twiddle
        $Output[$i+$Len_Over_2] = $Even[$i] - $Twiddle
    }

    Return $Output
}
