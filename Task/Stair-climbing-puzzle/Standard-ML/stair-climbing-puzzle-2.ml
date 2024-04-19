fun step() = true

fun step_up() = while step() = false do step_up()
