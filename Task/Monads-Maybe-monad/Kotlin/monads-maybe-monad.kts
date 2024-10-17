// version 1.2.10

import java.util.Optional

/* doubles 'i' before wrapping it */
fun getOptionalInt(i: Int) = Optional.of(2 * i)

/* returns an 'A' repeated 'i' times wrapped in an Optional<String> */
fun getOptionalString(i: Int) = Optional.of("A".repeat(i))

/* does same as above if i > 0, otherwise returns an empty Optional<String> */
fun getOptionalString2(i: Int) =
   Optional.ofNullable(if (i > 0) "A".repeat(i) else null)

fun main(args: Array<String>) {
    /* prints 10 'A's */
    println(getOptionalInt(5).flatMap(::getOptionalString).get())

    /* prints  4 'A's */
    println(getOptionalInt(2).flatMap(::getOptionalString2).get())

    /* prints 'false' as there is no value present in the Optional<String> instance */
    println(getOptionalInt(0).flatMap(::getOptionalString2).isPresent)
}
