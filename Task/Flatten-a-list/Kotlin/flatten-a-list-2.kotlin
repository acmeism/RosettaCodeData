fun flatten(list: List<*>): List<*> {
    fun flattenElement(elem: Any?): Iterable<*> {
        return if (elem is List<*>)
            if (elem.isEmpty()) elem
            else flattenElement(elem.first()) + flattenElement(elem.drop(1))
        else listOf(elem)
    }
    return list.flatMap { elem -> flattenElement(elem) }
}
