$txt=$null
1..100 | ForEach-Object {
    switch ($_) {
        { $_ % 3 -eq 0 }  { $txt+="Fizz" }
        { $_ % 5 -eq 0 }  { $txt+="Buzz" }
        $_                { if($txt) { $txt } else { $_ }; $txt=$null }
    }
}
