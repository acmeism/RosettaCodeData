Param([int]$Year = 1969)
Begin {
    $COL_WIDTH = 21
    $COLS = 3
    $MONTH_COUNT = 12
    $MONTH_LINES = 9

    Function CenterStr([string]$s, [int]$lineSize) {
        $padSize = [int](($lineSize - $s.Length) / 2)
        ($(if ($padSize -gt 0) { ' ' * $padSize } else { '' }) + $s).PadRight($lineSize,' ')
    }

    Function MonthLines([int]$month) {
        $dt = [System.DateTime]::new($Year, $month, 1)
        $line = CenterStr $dt.ToString("MMMM") $COL_WIDTH
        $line += 'Su Mo Tu We Th Fr Sa'
        $line += $('   ' * $dt.DayOfWeek.value__)
        $line += (-join ($(1..$($dt.AddMonths(1).AddDays(-1).Day)) | %{ $("" + $_).PadLeft(3) }))
        $line = $line.PadRight($MONTH_LINES * $COL_WIDTH)
        New-Object –TypeName PSObject –Prop(@{
            'Lines'=(0..($MONTH_LINES - 1)) | %{ $_ * $COL_WIDTH } | %{ -join $line[$_..($_ + $COL_WIDTH - 1)] }
            'Dt'=$dt})
    }
}
Process {
    Write-Output (CenterStr $Year ($COL_WIDTH * $COLS + 4))
    $(0..($MONTH_COUNT / $COLS - 1)) | %{
        $fm = $_ * $COLS
        $monthNums = $fm..($fm + $COLS - 1) | %{ $_ + 1 }
        $months = $monthNums | %{ MonthLines $_ }
        $(0..($MONTH_LINES - 1)) | %{
            $ml = $_
            Write-Output $(-join ($(0..($COLS - 1)) | %{ $(if ($_ -eq 0) { '' } else {'  '}) + $months[$_].Lines[$ml] }))
        }
    }
}
