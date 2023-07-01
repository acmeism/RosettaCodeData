using Dates

const cycles = ["Physical" => 23, "Emotional" => 28,"Mental" => 33]
const quadrants = [("up and rising", "peak"), ("up but falling", "transition"),
                   ("down and falling", "valley"), ("down but rising", "transition")]

function tellfortune(birthday::Date, date = today())
    days = (date - birthday).value
    target = (date - Date(0)).value
    println("Born $birthday, target date $date\nDay $days:")
    for (label, length) in cycles
        position = days % length
        quadrant = Int(floor((4 * position) / length)) + 1
        percentage = round(100 * sinpi(2 * position / length), digits=1)
        transition = target - position + (length * quadrant) ÷ 4
        trend, next = quadrants[quadrant]
        description = (percentage > 95) ? "peak" :
                      (percentage < -95) ? "valley" :
                      (abs(percentage) < 5) ? "critical transition" :
                      "$percentage% ($trend, next $next $(Date(0) + Dates.Day(transition)))"
        println("$label day $position: $description")
    end
    println()
end

tellfortune(Date("1943-03-09"), Date("1972-07-11"))
tellfortune(Date("1809-01-12"), Date("1863-11-19"))
tellfortune(Date("1809-02-12"), Date("1863-11-19"))
