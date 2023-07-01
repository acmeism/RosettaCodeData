object SearchListOfRecords extends App {
  val cities = Vector(
    City("Lagos", 21.0e6),
    City("Cairo", 15.2e6),
    City("Kinshasa-Brazzaville", 11.3e6),
    City("Greater Johannesburg", 7.55e6),
    City("Mogadishu", 5.85e6),
    City("Khartoum-Omdurman", 4.98e6),
    City("Dar Es Salaam", 4.7e6),
    City("Alexandria", 4.58e6),
    City("Abidjan", 4.4e6),
    City("Casablanca", 3.98e6)
  )

  def index = cities.indexWhere((_: City).name == "Dar Es Salaam")

  def name = cities.find(_.pop < 5.0e6).map(_.name)

  def pop = cities.find(_.name(0) == 'A').map(_.pop)

  case class City(name: String, pop: Double)

  println(
    s"Index of first city whose name is 'Dar Es Salaam'          = $index\n" +
      s"Name of first city whose population is less than 5 million = ${name.get}\n" +
      f"Population of first city whose name starts with 'A'        = ${pop.get}%,.0f")

}
