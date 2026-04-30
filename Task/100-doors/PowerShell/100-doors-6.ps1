Workflow Calc-Doors {
    Foreach –parallel ($number in 1..100) {
        "Door " + $number.ToString("0000") + ": " + @{$true="Closed";$false="Open"}[([Math]::pow($number, 0.5)%1) -ne 0]
    }
}
Calc-Doors | sort
