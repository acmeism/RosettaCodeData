data class Ref<T>(var value: T) {
    fun swap(other: Ref<T>) {
        val tmp = this.value
        this.value = other.value
        other.value = tmp
    }
    override fun toString() = "$value"
}
​
fun main() {
    val a = Ref(1)
    val b = Ref(2)
    a.swap(b)
    println(a)
    println(b)
}
