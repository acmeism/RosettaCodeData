fun findName(names: Map<String, String>, firstName: String) {
    require(names.isNotEmpty()) { "Please pass a non-empty names map" } // IllegalArgumentException
    val lastName = requireNotNull(names[name]) { "names is expected to contain name" } // IllegalArgumentException

    val fullName = "$firstName $lastName"
    check(fullName.contains(" ")) { "fullname was expected to have a space...?" } // IllegalStateException
    return fullName
}
