function flatten($a) {
    if($a.Count -gt 1) {
        $a | foreach{ $(flatten $_)}
    } else {$a}
}
$a = @(@(1), 2, @(@(3,4), 5), @(@(@())), @(@(@(6))), 7, 8, @())
"$(flatten $a)"
