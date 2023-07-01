// version 1.1.2

class City(val name: String, val pop: Double)

val cities = listOf(
    City("Lagos", 21.0),
    City("Cairo", 15.2),
    City("Kinshasa-Brazzaville", 11.3),
    City("Greater Johannesburg", 7.55),
    City("Mogadishu", 5.85),
    City("Khartoum-Omdurman", 4.98),
    City("Dar Es Salaam", 4.7),
    City("Alexandria", 4.58),
    City("Abidjan", 4.4),
    City("Casablanca", 3.98)
)

fun main(args: Array<String>) {
    val index = cities.indexOfFirst { it.name == "Dar Es Salaam" }
    println("Index of first city whose name is 'Dar Es Salaam'          = $index")
    val name = cities.first { it.pop < 5.0 }.name
    println("Name of first city whose population is less than 5 million = $name")
    val pop = cities.first { it.name[0] == 'A' }.pop
    println("Population of first city whose name starts with 'A'        = $pop")
}
