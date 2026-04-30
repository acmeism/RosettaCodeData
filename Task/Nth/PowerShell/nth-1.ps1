function nth($inp){
    $suffix = "th"

    switch($inp % 100){
        11{$suffix="th"}
        12{$suffix="th"}
        13{$suffix="th"}
        default{
            switch($inp % 10){
                1{$suffix="st"}
                2{$suffix="nd"}
                3{$suffix="rd"}
            }
        }
    }
    return "$inp$suffix "
}

0..25 | %{Write-host -nonewline (nth "$_")};""
250..265 | %{Write-host -nonewline (nth "$_")};""
1000..1025 | %{Write-host -nonewline (nth "$_")};""
