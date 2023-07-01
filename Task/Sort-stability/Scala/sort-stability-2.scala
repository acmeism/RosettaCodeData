scala> val cityArray = cities.toArray
cityArray: Array[String] = Array(UK  London, US  New York, US  Birmingham, UK  Birmingham)

scala> scala.util.Sorting.stableSort(cityArray, (_: String).substring(4) < (_: String).substring(4))

scala> cityArray
res56: Array[String] = Array(US  Birmingham, UK  Birmingham, UK  London, US  New York)
