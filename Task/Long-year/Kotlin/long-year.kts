fun main() {
    val has53Weeks = { year: Int -> LocalDate.of(year, 12, 28).get(WeekFields.ISO.weekOfYear()) == 53 }
    println("Long years this century:")
    (2000..2100).filter(has53Weeks)
        .forEach { year -> print("$year ")}
}
