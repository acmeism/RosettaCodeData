   $argv,$options = parseOptions $args $options

    if ($options.opt3) {
        $foo = $blah - ($yada * $options.opt1) + ($yada * $options.opt2)
        $bar = $argv | SomeOtherFilter | Baz
    }
