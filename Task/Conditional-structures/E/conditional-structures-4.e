def expression := ["+", [1, 2]]

def value := switch (expression) {
    match [`+`, [a, b]] { a + b }
    match [`*`, [a, b]] { a * b }
    match [op, _] { throw(`unknown operator: $op`) }
}
