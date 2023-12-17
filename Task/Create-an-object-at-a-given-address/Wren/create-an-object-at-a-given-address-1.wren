/* Create_an_object_at_a_given_address.wren */

import "./fmt" for Fmt

foreign class Integer {
    construct new(i) {}

    foreign value

    foreign value=(i)

    foreign address
}

var i = Integer.new(42)
Fmt.print("Integer object with value of:    $d allocated at address $#x.", i.value, i.address)
i.value = 42
Fmt.print("Integer object value reset to:   $d but still at address $#x.", i.value, i.address)
i.value = 43
Fmt.print("Integer object value changed to: $d but still at address $#x.", i.value, i.address)
