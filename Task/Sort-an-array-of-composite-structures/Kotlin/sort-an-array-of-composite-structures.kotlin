// version 1.1

data class Employee(val name: String, var category: String) : Comparable<Employee> {
    override fun compareTo(other: Employee) = this.name.compareTo(other.name)
}

fun main(args: Array<String>) {
    val employees = arrayOf(
        Employee("David", "Manager"),
        Employee("Alice", "Sales"),
        Employee("Joanna", "Director"),
        Employee("Henry", "Admin"),
        Employee("Tim", "Sales"),
        Employee("Juan", "Admin")
    )
    employees.sort()
    for ((name, category) in employees) println("${name.padEnd(6)} : $category")
}
