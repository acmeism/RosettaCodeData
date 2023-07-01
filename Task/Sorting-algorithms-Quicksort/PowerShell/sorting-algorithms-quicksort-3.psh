function quicksort($in) {
    $n = $in.count
    switch ($n) {
        0 {}
        1 { $in[0] }
        2 { if ($in[0] -lt $in[1]) {$in[0], $in[1]} else {$in[1], $in[0]} }
        default {
            $pivot = $in | get-random
            $lt = $in | ? {$_ -lt $pivot}
            $eq = $in | ? {$_ -eq $pivot}
            $gt = $in | ? {$_ -gt $pivot}
            @(quicksort $lt) + @($eq) + @(quicksort $gt)
        }
    }
}
