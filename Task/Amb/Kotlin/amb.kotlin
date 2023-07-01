// version 1.2.41
import kotlin.coroutines.experimental.*
import kotlin.coroutines.experimental.intrinsics.*

fun main(args: Array<String>) = amb {
    val a = amb("the", "that", "a")
    val b = amb("frog", "elephant", "thing")
    val c = amb("walked", "treaded", "grows")
    val d = amb("slowly", "quickly")

    if (a[a.lastIndex] != b[0]) amb()
    if (b[b.lastIndex] != c[0]) amb()
    if (c[c.lastIndex] != d[0]) amb()

    println(listOf(a, b, c, d))


    val x = amb(1, 2, 3)
    val y = amb(7, 6, 4, 5)
    if (x * y != 8) amb()
    println(listOf(x, y))
}


class AmbException(): Exception("Refusing to execute")
data class AmbPair<T>(val cont: Continuation<T>, val valuesLeft: MutableList<T>)

@RestrictsSuspension
class AmbEnvironment {
    val ambList = mutableListOf<AmbPair<*>>()

    suspend fun <T> amb(value: T, vararg rest: T): T = suspendCoroutineOrReturn { cont ->
        if (rest.size > 0) {
            ambList.add(AmbPair(clone(cont), mutableListOf(*rest)))
        }

        value
    }

    suspend fun amb(): Nothing = suspendCoroutine<Nothing> { }
}

@Suppress("UNCHECKED_CAST")
fun <R> amb(block: suspend AmbEnvironment.() -> R): R {
    var result: R? = null
    var toThrow: Throwable? = null

    val dist = AmbEnvironment()
    block.startCoroutine(receiver = dist, completion = object : Continuation<R> {
        override val context: CoroutineContext get() = EmptyCoroutineContext
        override fun resume(value: R) { result = value }
        override fun resumeWithException(exception: Throwable) { toThrow = exception }
    })

    while (result == null && toThrow == null && !dist.ambList.isEmpty()) {
        val last = dist.ambList.run { this[lastIndex] }

        if (last.valuesLeft.size == 1) {
            dist.ambList.removeAt(dist.ambList.lastIndex)
            last.apply {
                (cont as Continuation<Any?>).resume(valuesLeft[0])
            }
        } else {
            val value = last.valuesLeft.removeAt(last.valuesLeft.lastIndex)
            (clone(last.cont) as Continuation<Any?>).resume(value)
        }
    }

    if (toThrow != null)
    {
        throw toThrow!!
    }
    else if (result != null)
    {
        return result!!
    }
    else
    {
        throw AmbException()
    }
}

val UNSAFE = Class.forName("sun.misc.Unsafe")
    .getDeclaredField("theUnsafe")
    .apply { isAccessible = true }
    .get(null) as sun.misc.Unsafe

@Suppress("UNCHECKED_CAST")
fun <T: Any> clone(obj: T): T {
    val clazz = obj::class.java
    val copy = UNSAFE.allocateInstance(clazz) as T
    copyDeclaredFields(obj, copy, clazz)
    return copy
}

tailrec fun <T> copyDeclaredFields(obj: T, copy: T, clazz: Class<out T>) {
    for (field in clazz.declaredFields) {
        field.isAccessible = true
        val v = field.get(obj)
        field.set(copy, if (v === obj) copy else v)
    }
    val superclass = clazz.superclass
    if (superclass != null) copyDeclaredFields(obj, copy, superclass)
}
