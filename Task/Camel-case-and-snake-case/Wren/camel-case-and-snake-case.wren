import "./str" for Char
import "./fmt" for Fmt

var toCamel = Fn.new { |snake|
    snake = snake.trim()
    var camel = ""
    var underscore = false
    for (c in snake) {
        if ("_- ".contains(c)) {
            underscore = true
        } else if (underscore) {
            camel = camel + Char.upper(c)
            underscore = false
        } else {
            camel = camel + c
        }
    }
    return camel
}

var toSnake = Fn.new { |camel|
    camel = camel.trim().replace(" ", "_") // we don't want any spaces in the result
    var snake = ""
    var first = true
    for (c in camel) {
        if (first) {
            snake = snake + c
            first = false
        } else if (!first && Char.isUpper(c)) {
            if (snake[-1] == "_" || snake[-1] == "-") {
                snake = snake + Char.lower(c)
            } else {
                snake = snake + "_" + Char.lower(c)
            }
        } else {
            snake = snake + c
        }
    }
    return snake
}

var tests = [
    "snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis",
    "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
]

System.print("                          === to_snake_case ===")
for (camel in tests) {
    Fmt.print("$33s -> $s", camel, toSnake.call(camel))
}

System.print("\n                         === toCamelCase ===")
for (snake in tests) {
    Fmt.print("$33s -> $s", snake, toCamel.call(snake))
}
