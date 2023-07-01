// version 1.0.6

const val SOLAR_DIAMETER = 864938

enum class Planet { MERCURY, VENUS, EARTH, MARS, JUPITER, SATURN, URANUS, NEPTUNE, PLUTO } // Yeah, Pluto!

class Star(val name: String) {
    fun showDiameter() {
        println("The diameter of the $name is ${"%,d".format(SOLAR_DIAMETER)} miles")
    }
}

class SolarSystem(val star: Star) {
    private val planets = mutableListOf<Planet>()  // some people might prefer _planets

    init {
       for (planet in Planet.values()) planets.add(planet)
    }

    fun listPlanets() {
       println(planets)
    }
}

fun main(args: Array<String>) {
    val sun = Star("sun")
    val ss = SolarSystem(sun)
    sun.showDiameter()
    println("\nIts planetary system comprises : ")
    ss.listPlanets()
}
