 ( [['0b0' 2] [1 10] [1234 10] ['0xfe' 16] ['0xf0e' 16]] |
  each {|n|
    let base = $n.1
    let num = match $base {
        16 => {$n.0 | str replace '0x' '' | str downcase},
        2  => {$n.0 | str replace '0b' '' | str downcase},
        _  => {$n.0 | into string},
    }
    # Split the number into characters and sum the digits
     $num | split chars | each {|digit|
        $digit | into int -r $base
    } | math sum
  } )
