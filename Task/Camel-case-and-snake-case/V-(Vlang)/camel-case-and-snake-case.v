fn to_camel(snake string) string {
    mut camel := ''
    mut underscore := false
    letters := snake.trim(' ').runes()
    for c in letters {
        if c.str() in [' ','-','_'] {
            underscore = true
        } else if underscore {
            camel += c.str().to_upper()
            underscore = false
        } else {
            camel += c.str()
        }
    }
    return camel
}
fn to_snake(camel string) string {
    mut snake := ''
    mut first := true
    letters := camel.trim(' ').replace(' ','_').runes()
    for c in letters {
        if first {
            snake+=c.str()
            first = false
        } else if !first && (c.str().is_upper() && c.bytes().len ==1 && c.bytes()[0].is_letter()) {
            if snake[snake.len-1..snake.len] == '_' || snake[snake.len-1..snake.len] == '-' {
                snake += c.str().to_lower()
            }else {
                snake += '_'+c.str().to_lower()
            }
        }else{
            snake+=c.str()
        }
    }
    return snake
}
const tests = ["snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis",
    "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "]
fn main() {
    println('                          === to_snake_case ===')
    for word in tests {
        println('${word:33} -> ${to_snake(word)}')
    }
    println('                          === to_camel_case ===')
    for word in tests {
        println('${word:33} -> ${to_camel(word)}')
    }
}
