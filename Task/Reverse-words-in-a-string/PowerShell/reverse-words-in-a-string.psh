Function Reverse-Words($lines) {
    $lines | foreach {
        $array = $PSItem.Split(' ')
        $array[($array.Count-1)..0] -join ' '
    }
}

$lines =
"---------- Ice and Fire ------------",
"",
"fire, in end will world the say Some",
"ice. in say Some",
"desire of tasted I've what From",
"fire. favor who those with hold I",
"",
"... elided paragraph last ...",
"",
"Frost Robert -----------------------"

Reverse-Words($lines)
