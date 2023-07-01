? if (true) { "a" } else { "b" }
# value: "a"

? if (false) { "a" } else { "b" }
# value: "b"

? if (90) { "a" } else { "b" }
# problem: the int 90 doesn't coerce to a boolean
