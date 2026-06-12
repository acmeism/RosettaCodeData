import java.util.regex.Pattern

class ChemicalCalculator {
    private static final Map<String, Double> ATOMIC_MASS = new HashMap<>()

    static {
        ATOMIC_MASS.put("H", 1.008)
        ATOMIC_MASS.put("He", 4.002602)
        ATOMIC_MASS.put("Li", 6.94)
        ATOMIC_MASS.put("Be", 9.0121831)
        ATOMIC_MASS.put("B", 10.81)
        ATOMIC_MASS.put("C", 12.011)
        ATOMIC_MASS.put("N", 14.007)
        ATOMIC_MASS.put("O", 15.999)
        ATOMIC_MASS.put("F", 18.998403163)
        ATOMIC_MASS.put("Ne", 20.1797)
        ATOMIC_MASS.put("Na", 22.98976928)
        ATOMIC_MASS.put("Mg", 24.305)
        ATOMIC_MASS.put("Al", 26.9815385)
        ATOMIC_MASS.put("Si", 28.085)
        ATOMIC_MASS.put("P", 30.973761998)
        ATOMIC_MASS.put("S", 32.06)
        ATOMIC_MASS.put("Cl", 35.45)
        ATOMIC_MASS.put("Ar", 39.948)
        ATOMIC_MASS.put("K", 39.0983)
        ATOMIC_MASS.put("Ca", 40.078)
        ATOMIC_MASS.put("Sc", 44.955908)
        ATOMIC_MASS.put("Ti", 47.867)
        ATOMIC_MASS.put("V", 50.9415)
        ATOMIC_MASS.put("Cr", 51.9961)
        ATOMIC_MASS.put("Mn", 54.938044)
        ATOMIC_MASS.put("Fe", 55.845)
        ATOMIC_MASS.put("Co", 58.933194)
        ATOMIC_MASS.put("Ni", 58.6934)
        ATOMIC_MASS.put("Cu", 63.546)
        ATOMIC_MASS.put("Zn", 65.38)
        ATOMIC_MASS.put("Ga", 69.723)
        ATOMIC_MASS.put("Ge", 72.630)
        ATOMIC_MASS.put("As", 74.921595)
        ATOMIC_MASS.put("Se", 78.971)
        ATOMIC_MASS.put("Br", 79.904)
        ATOMIC_MASS.put("Kr", 83.798)
        ATOMIC_MASS.put("Rb", 85.4678)
        ATOMIC_MASS.put("Sr", 87.62)
        ATOMIC_MASS.put("Y", 88.90584)
        ATOMIC_MASS.put("Zr", 91.224)
        ATOMIC_MASS.put("Nb", 92.90637)
        ATOMIC_MASS.put("Mo", 95.95)
        ATOMIC_MASS.put("Ru", 101.07)
        ATOMIC_MASS.put("Rh", 102.90550)
        ATOMIC_MASS.put("Pd", 106.42)
        ATOMIC_MASS.put("Ag", 107.8682)
        ATOMIC_MASS.put("Cd", 112.414)
        ATOMIC_MASS.put("In", 114.818)
        ATOMIC_MASS.put("Sn", 118.710)
        ATOMIC_MASS.put("Sb", 121.760)
        ATOMIC_MASS.put("Te", 127.60)
        ATOMIC_MASS.put("I", 126.90447)
        ATOMIC_MASS.put("Xe", 131.293)
        ATOMIC_MASS.put("Cs", 132.90545196)
        ATOMIC_MASS.put("Ba", 137.327)
        ATOMIC_MASS.put("La", 138.90547)
        ATOMIC_MASS.put("Ce", 140.116)
        ATOMIC_MASS.put("Pr", 140.90766)
        ATOMIC_MASS.put("Nd", 144.242)
        ATOMIC_MASS.put("Pm", 145.0)
        ATOMIC_MASS.put("Sm", 150.36)
        ATOMIC_MASS.put("Eu", 151.964)
        ATOMIC_MASS.put("Gd", 157.25)
        ATOMIC_MASS.put("Tb", 158.92535)
        ATOMIC_MASS.put("Dy", 162.500)
        ATOMIC_MASS.put("Ho", 164.93033)
        ATOMIC_MASS.put("Er", 167.259)
        ATOMIC_MASS.put("Tm", 168.93422)
        ATOMIC_MASS.put("Yb", 173.054)
        ATOMIC_MASS.put("Lu", 174.9668)
        ATOMIC_MASS.put("Hf", 178.49)
        ATOMIC_MASS.put("Ta", 180.94788)
        ATOMIC_MASS.put("W", 183.84)
        ATOMIC_MASS.put("Re", 186.207)
        ATOMIC_MASS.put("Os", 190.23)
        ATOMIC_MASS.put("Ir", 192.217)
        ATOMIC_MASS.put("Pt", 195.084)
        ATOMIC_MASS.put("Au", 196.966569)
        ATOMIC_MASS.put("Hg", 200.592)
        ATOMIC_MASS.put("Tl", 204.38)
        ATOMIC_MASS.put("Pb", 207.2)
        ATOMIC_MASS.put("Bi", 208.98040)
        ATOMIC_MASS.put("Po", 209.0)
        ATOMIC_MASS.put("At", 210.0)
        ATOMIC_MASS.put("Rn", 222.0)
        ATOMIC_MASS.put("Fr", 223.0)
        ATOMIC_MASS.put("Ra", 226.0)
        ATOMIC_MASS.put("Ac", 227.0)
        ATOMIC_MASS.put("Th", 232.0377)
        ATOMIC_MASS.put("Pa", 231.03588)
        ATOMIC_MASS.put("U", 238.02891)
        ATOMIC_MASS.put("Np", 237.0)
        ATOMIC_MASS.put("Pu", 244.0)
        ATOMIC_MASS.put("Am", 243.0)
        ATOMIC_MASS.put("Cm", 247.0)
        ATOMIC_MASS.put("Bk", 247.0)
        ATOMIC_MASS.put("Cf", 251.0)
        ATOMIC_MASS.put("Es", 252.0)
        ATOMIC_MASS.put("Fm", 257.0)
        ATOMIC_MASS.put("Uue", 315.0)
        ATOMIC_MASS.put("Ubn", 299.0)
    }

    private static double evaluate(String s) {
        String sym = s + "["
        double sum = 0.0
        StringBuilder symbol = new StringBuilder()
        String number = ""
        for (int i = 0; i < sym.length(); ++i) {
            char c = sym.charAt(i)
            if (('@' as char) <= c && c <= ('[' as char)) {
                // @, A-Z, [
                int n = 1
                if (!number.isEmpty()) {
                    n = Integer.parseInt(number)
                }
                if (symbol.length() > 0) {
                    sum += ATOMIC_MASS.getOrDefault(symbol.toString(), 0.0) * n
                }
                if (c == '[' as char) {
                    break
                }
                symbol = new StringBuilder(String.valueOf(c))
                number = ""
            } else if (('a' as char) <= c && c <= ('z' as char)) {
                symbol.append(c)
            } else if (('0' as char) <= c && c <= ('9' as char)) {
                number += c
            } else {
                throw new RuntimeException("Unexpected symbol " + c + " in molecule")
            }
        }
        return sum
    }

    private static String replaceParens(String s) {
        char letter = 'a'
        String si = s
        while (true) {
            int start = si.indexOf('(')
            if (start == -1) {
                break
            }

            for (int i = start + 1; i < si.length(); ++i) {
                if (si.charAt(i) == (')' as char)) {
                    String expr = si.substring(start + 1, i)
                    String symbol = "@" + letter
                    String pattern = Pattern.quote(si.substring(start, i + 1))
                    si = si.replaceFirst(pattern, symbol)
                    ATOMIC_MASS.put(symbol, evaluate(expr))
                    letter++
                    break
                }
                if (si.charAt(i) == ('(' as char)) {
                    start = i
                }
            }
        }
        return si
    }

    static void main(String[] args) {
        List<String> molecules = [
                "H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12",
                "COOH(C(CH3)2)3CH3", "C6H4O2(OH)4", "C27H46O", "Uue"
        ]
        for (String molecule : molecules) {
            double mass = evaluate(replaceParens(molecule))
            printf("%17s -> %7.3f\n", molecule, mass)
        }
    }
}
