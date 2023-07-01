var assertEnabled = true

var assert = Fn.new { |cond|
    if (assertEnabled && !cond) Fiber.abort("Assertion failure")
}

var x = 42
assert.call(x == 42)  // fine
assertEnabled = false
assert.call(x > 42)   // no error
assertEnabled = true
assert.call(x > 42)   // error
