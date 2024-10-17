fun main() {
    val variableNames = listOf("snakeCase", "snake_case", "variable_10_case", "variable10Case",
        "ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  ")

    println(" ".repeat(26) + "=== To snake_case ===")
    variableNames.forEach { text ->
        println("${text.padStart(34)} --> ${toSnakeCase(text)}")
    }

    println("\n" + " ".repeat(26) + "=== To camelCase ===")
    variableNames.forEach { text ->
        println("${text.padStart(34)} --> ${toCamelCase(text)}")
    }
}

fun toSnakeCase(camel: String): String {
    val snake = StringBuilder()
    camel.trim().replace(" ", "_").replace("-", "_").forEach { ch ->
        if (snake.isEmpty() || snake.last() != '_' || ch != '_') {
            if (ch.isUpperCase() && snake.isNotEmpty() && snake.last() != '_') snake.append('_')
            snake.append(ch.toLowerCase())
        }
    }
    return snake.toString()
}

fun toCamelCase(snake: String): String {
    val camel = StringBuilder()
    var underscore = false
    snake.trim().replace(" ", "_").replace("-", "_").forEach { ch ->
        if (ch == '_') {
            underscore = true
        } else if (underscore) {
            camel.append(ch.toUpperCase())
            underscore = false
        } else {
            camel.append(ch)
        }
    }
    return camel.toString()
}
