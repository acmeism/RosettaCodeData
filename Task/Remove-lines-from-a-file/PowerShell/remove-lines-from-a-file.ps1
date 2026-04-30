function del-line($file, $start, $end) {
    $i = 0
    $start--
    $end--
    (Get-Content $file) | where{
        ($i -lt $start -or $i -gt $end)
        $i++
    } > $file
    (Get-Content $file)
}
del-line "foobar.txt" 1 2
