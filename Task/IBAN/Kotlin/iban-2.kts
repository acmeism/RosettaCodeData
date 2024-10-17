package rosettacode

import rosettacode.Outcome.Fail
import rosettacode.Outcome.Ok
import java.lang.IllegalArgumentException
import java.math.BigInteger

sealed class Outcome {

    object Ok : Outcome() {
        override fun toString(): String = "Ok"
    }

    data class Fail(val error: String) : Outcome()
}

fun Boolean.asOutcome(error: String = "") = when (this) {
    true -> Ok
    false -> Fail(error)
}

/**
 * A validator based on a pattern (e.g GB2!n4!a6!n8!n) as defined in the IBAN REGISTRY
 * Doesn't handle variable length IBANs - sufficient for Rosetta
 *
 * IBAN REGISTRY: https://www.swift.com/swift_resource/9606
 */
class Validator(private val pattern: String) {
    private val triplet: Regex = """(\d+)!([n,a,c])""".toRegex() // e.g: 10!n
    private val rules: List<Regex>

    init {
        val countTypePairs = triplet
            .findAll(pattern)
            .map { Pair(it.groups[1]!!.value.toInt(), it.groups[2]!!.value) }

        rules = countTypePairs.fold(emptyList()) { acc, p ->
            acc + when (p.second) {
                "n" -> """[0-9]{${p.first}}""".toRegex()
                "a" -> """[A-Z]{${p.first}}""".toRegex()
                "c" -> """[A-Z,0-9]{${p.first}}""".toRegex()
                else -> throw IllegalArgumentException("Unexpected pattern: $pattern")
            }
        }
    }

    fun isValid(ccbban: String): Outcome {
        var k = 0

        for (rule in rules) {
            when (val match = rule.matchAt(ccbban, k)) {
                null -> return Fail("failed rule: $rule")
                else -> {
                    k = match.range.last + 1
                }
            }
        }
        return (k == ccbban.length).asOutcome("IBAN is too long")
    }
}

object Registry : MutableMap<String, Validator> by mutableMapOf()

fun String.split(i: Int) = Pair(this.substring(0, i), this.substring(i))
fun String.toDigits() = this.fold("") { acc, ch -> acc + Character.getNumericValue(ch) }
fun Pair<String, String>.swap() = this.second + this.first

object CDCheck {
    private val _97 = BigInteger.valueOf(97)
    private val _1 = BigInteger.ONE

    operator fun invoke(digits: String) = (BigInteger(digits).mod(_97) == _1).asOutcome("Invalid Check Digits")
}

fun validate(iban: String): Outcome {
    val normalized = iban.replace(" ", "").uppercase().also {
        if (it.length < 5) {
            return Fail("IBAN is too short")
        }
    }

    val (cc, tail) = normalized.split(2)
    val validator = Registry[cc] ?: return Fail("Unknown Country Code: $cc")

    return when (val outcome = validator.isValid(tail)) {
        is Fail -> outcome
        is Ok -> {
            val allDigits = normalized
                .split(4).swap() // (CC + CD) -> end
                .toDigits()      // letters -> digits
            CDCheck(allDigits)
        }
    }
}

fun main() {
    Registry["GB"] = Validator("GB2!n4!a6!n8!n")
    Registry["DE"] = Validator("DE2!n8!n10!n")

    validate("GB82WEST12345698765432").also { println(it) } // Ok
    validate("GB82 WEST 1234 5698 7654 32").also { println(it) } // Ok

    validate("DE89370400440532013000").also { println(it) } // Ok

    validate("XX82WEST1234569A765432").also { println(it) } // Unknown Country Code: XX
    validate("GB82").also { println(it) } // IBAN is too short
    validate("GB82WEST1234569A765432").also { println(it) }  // failed rule: [0-9]{8}
    validate("GB82WE5T1234569A765432").also { println(it) }  // failed rule: [A-Z]{4}
    validate("GB82WEST123456987654329").also { println(it) } // IBAN is too long
    validate("GB80WEST12345698765432").also { println(it) }  // Invalid Check Digits
}
