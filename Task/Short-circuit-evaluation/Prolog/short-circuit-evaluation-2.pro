?- short_circuit.
a(true) or b(true)
a(true)
==> true

a(true) or b(false)
a(true)
==> true

a(false) or b(true)
a(false)
b(true)
==> true

a(false) or b(false)
a(false)
b(false)
==> false

a(true) and b(true)
a(true)
b(true)
==> true

a(true) and b(false)
a(true)
b(false)
==> false

a(false) and b(true)
a(false)
==> false

a(false) and b(false)
a(false)
==> false

true.
