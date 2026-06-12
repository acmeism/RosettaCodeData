var atomicMass = mutableMapOf(
    "H" to 1.008,
    "He" to 4.002602,
    "Li" to 6.94,
    "Be" to 9.0121831,
    "B" to 10.81,
    "C" to 12.011,
    "N" to 14.007,
    "O" to 15.999,
    "F" to 18.998403163,
    "Ne" to 20.1797,
    "Na" to 22.98976928,
    "Mg" to 24.305,
    "Al" to 26.9815385,
    "Si" to 28.085,
    "P" to 30.973761998,
    "S" to 32.06,
    "Cl" to 35.45,
    "Ar" to 39.948,
    "K" to 39.0983,
    "Ca" to 40.078,
    "Sc" to 44.955908,
    "Ti" to 47.867,
    "V" to 50.9415,
    "Cr" to 51.9961,
    "Mn" to 54.938044,
    "Fe" to 55.845,
    "Co" to 58.933194,
    "Ni" to 58.6934,
    "Cu" to 63.546,
    "Zn" to 65.38,
    "Ga" to 69.723,
    "Ge" to 72.630,
    "As" to 74.921595,
    "Se" to 78.971,
    "Br" to 79.904,
    "Kr" to 83.798,
    "Rb" to 85.4678,
    "Sr" to 87.62,
    "Y" to 88.90584,
    "Zr" to 91.224,
    "Nb" to 92.90637,
    "Mo" to 95.95,
    "Ru" to 101.07,
    "Rh" to 102.90550,
    "Pd" to 106.42,
    "Ag" to 107.8682,
    "Cd" to 112.414,
    "In" to 114.818,
    "Sn" to 118.710,
    "Sb" to 121.760,
    "Te" to 127.60,
    "I" to 126.90447,
    "Xe" to 131.293,
    "Cs" to 132.90545196,
    "Ba" to 137.327,
    "La" to 138.90547,
    "Ce" to 140.116,
    "Pr" to 140.90766,
    "Nd" to 144.242,
    "Pm" to 145.0,
    "Sm" to 150.36,
    "Eu" to 151.964,
    "Gd" to 157.25,
    "Tb" to 158.92535,
    "Dy" to 162.500,
    "Ho" to 164.93033,
    "Er" to 167.259,
    "Tm" to 168.93422,
    "Yb" to 173.054,
    "Lu" to 174.9668,
    "Hf" to 178.49,
    "Ta" to 180.94788,
    "W" to 183.84,
    "Re" to 186.207,
    "Os" to 190.23,
    "Ir" to 192.217,
    "Pt" to 195.084,
    "Au" to 196.966569,
    "Hg" to 200.592,
    "Tl" to 204.38,
    "Pb" to 207.2,
    "Bi" to 208.98040,
    "Po" to 209.0,
    "At" to 210.0,
    "Rn" to 222.0,
    "Fr" to 223.0,
    "Ra" to 226.0,
    "Ac" to 227.0,
    "Th" to 232.0377,
    "Pa" to 231.03588,
    "U" to 238.02891,
    "Np" to 237.0,
    "Pu" to 244.0,
    "Am" to 243.0,
    "Cm" to 247.0,
    "Bk" to 247.0,
    "Cf" to 251.0,
    "Es" to 252.0,
    "Fm" to 257.0,
    "Uue" to 315.0,
    "Ubn" to 299.0
)

fun evaluate(s: String): Double {
    val sym = "$s["
    var sum = 0.0
    var symbol = ""
    var number = ""
    for (i in 0 until sym.length) {
        val c = sym[i]
        if (c in '@'..'[') {
            // @, A-Z, [
            var n = 1
            if (number != "") {
                n = Integer.parseInt(number)
            }
            if (symbol != "") {
                sum += atomicMass.getOrElse(symbol) { 0.0 } * n
            }
            if (c == '[') {
                break
            }
            symbol = c.toString()
            number = ""
        } else if (c in 'a'..'z') {
            symbol += c
        } else if (c in '0'..'9') {
            number += c
        } else {
            throw RuntimeException("Unexpected symbol $c in molecule")
        }
    }
    return sum
}

fun replaceParens(s: String): String {
    var letter = 'a'
    var si = s
    while (true) {
        var start = si.indexOf('(')
        if (start == -1) {
            break
        }

        for (i in start + 1 until si.length) {
            if (si[i] == ')') {
                val expr = si.substring(start + 1 until i)
                val symbol = "@$letter"
                si = si.replaceFirst(si.substring(start until i + 1), symbol)
                atomicMass[symbol] = evaluate(expr)
                letter++
                break
            }
            if (si[i] == '(') {
                start = i
                continue
            }
        }
    }
    return si
}

fun main() {
    val molecules = listOf(
        "H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12",
        "COOH(C(CH3)2)3CH3", "C6H4O2(OH)4", "C27H46O", "Uue"
    )
    for (molecule in molecules) {
        val mass = evaluate(replaceParens(molecule))
        val moleStr = "%17s".format(molecule)
        val massStr = "%7.3f".format(mass)
        println("$moleStr -> $massStr")
    }
}
