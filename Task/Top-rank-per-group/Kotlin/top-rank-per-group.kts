// version 1.1.2

data class Employee(val name: String, val id: String, val salary: Int, val dept: String)

const val N = 2 //say

fun main(args: Array<String>) {
    val employees = listOf(
        Employee("Tyler Bennett", "E10297", 32000, "D101"),
        Employee("John Rappl", "E21437", 47000, "D050"),
        Employee("George Woltman" , "E00127", 53500, "D101"),
        Employee("Adam Smith", "E63535", 18000, "D202"),
        Employee("Claire Buckman", "E39876", 27800, "D202"),
        Employee("David McClellan", "E04242", 41500, "D101"),
        Employee("Rich Holcomb", "E01234", 49500, "D202"),
        Employee("Nathan Adams", "E41298", 21900, "D050"),
        Employee("Richard Potter", "E43128", 15900, "D101"),
        Employee("David Motsinger", "E27002", 19250, "D202"),
        Employee("Tim Sampair", "E03033", 27000, "D101"),
        Employee("Kim Arlich", "E10001", 57000, "D190"),
        Employee("Timothy Grove", "E16398", 29900, "D190")
    )
    val employeesByDept = employees.sortedBy { it.dept }.groupBy { it.dept }
    println("Highest $N salaries by department:\n")
    for ((key, value) in employeesByDept) {
        val topRanked = value.sortedByDescending { it.salary }.take(N)
        println("Dept $key => ")
        for (i in 0 until N) with (topRanked[i]) { println("${name.padEnd(15)} $id $salary") }
        println()
    }
}
