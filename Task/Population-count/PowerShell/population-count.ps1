function pop-count($n) {
    (([Convert]::ToString($n, 2)).toCharArray() | where {$_ -eq '1'}).count
}
"pop_count 3^n: $(1..29 | foreach -Begin {$n = 1; (pop-count $n)} -Process {$n = 3*$n; (pop-count $n)} )"
"even pop_count: $($m = $n = 0; while($m -lt 30) {if(0 -eq ((pop-count $n)%2)) {$m += 1; $n}; $n += 1} )"
"odd pop_count: $($m = $n = 0; while($m -lt 30) {if(1 -eq ((pop-count $n)%2)) {$m += 1; $n}; $n += 1} )"
