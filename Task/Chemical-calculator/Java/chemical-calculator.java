import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class ChemicalCalculator {
    private static final Map<String, Double> atomicMass = new HashMap<>();

    static {
        atomicMass.put("H", 1.008);
        atomicMass.put("He", 4.002602);
        atomicMass.put("Li", 6.94);
        atomicMass.put("Be", 9.0121831);
        atomicMass.put("B", 10.81);
        atomicMass.put("C", 12.011);
        atomicMass.put("N", 14.007);
        atomicMass.put("O", 15.999);
        atomicMass.put("F", 18.998403163);
        atomicMass.put("Ne", 20.1797);
        atomicMass.put("Na", 22.98976928);
        atomicMass.put("Mg", 24.305);
        atomicMass.put("Al", 26.9815385);
        atomicMass.put("Si", 28.085);
        atomicMass.put("P", 30.973761998);
        atomicMass.put("S", 32.06);
        atomicMass.put("Cl", 35.45);
        atomicMass.put("Ar", 39.948);
        atomicMass.put("K", 39.0983);
        atomicMass.put("Ca", 40.078);
        atomicMass.put("Sc", 44.955908);
        atomicMass.put("Ti", 47.867);
        atomicMass.put("V", 50.9415);
        atomicMass.put("Cr", 51.9961);
        atomicMass.put("Mn", 54.938044);
        atomicMass.put("Fe", 55.845);
        atomicMass.put("Co", 58.933194);
        atomicMass.put("Ni", 58.6934);
        atomicMass.put("Cu", 63.546);
        atomicMass.put("Zn", 65.38);
        atomicMass.put("Ga", 69.723);
        atomicMass.put("Ge", 72.630);
        atomicMass.put("As", 74.921595);
        atomicMass.put("Se", 78.971);
        atomicMass.put("Br", 79.904);
        atomicMass.put("Kr", 83.798);
        atomicMass.put("Rb", 85.4678);
        atomicMass.put("Sr", 87.62);
        atomicMass.put("Y", 88.90584);
        atomicMass.put("Zr", 91.224);
        atomicMass.put("Nb", 92.90637);
        atomicMass.put("Mo", 95.95);
        atomicMass.put("Ru", 101.07);
        atomicMass.put("Rh", 102.90550);
        atomicMass.put("Pd", 106.42);
        atomicMass.put("Ag", 107.8682);
        atomicMass.put("Cd", 112.414);
        atomicMass.put("In", 114.818);
        atomicMass.put("Sn", 118.710);
        atomicMass.put("Sb", 121.760);
        atomicMass.put("Te", 127.60);
        atomicMass.put("I", 126.90447);
        atomicMass.put("Xe", 131.293);
        atomicMass.put("Cs", 132.90545196);
        atomicMass.put("Ba", 137.327);
        atomicMass.put("La", 138.90547);
        atomicMass.put("Ce", 140.116);
        atomicMass.put("Pr", 140.90766);
        atomicMass.put("Nd", 144.242);
        atomicMass.put("Pm", 145.0);
        atomicMass.put("Sm", 150.36);
        atomicMass.put("Eu", 151.964);
        atomicMass.put("Gd", 157.25);
        atomicMass.put("Tb", 158.92535);
        atomicMass.put("Dy", 162.500);
        atomicMass.put("Ho", 164.93033);
        atomicMass.put("Er", 167.259);
        atomicMass.put("Tm", 168.93422);
        atomicMass.put("Yb", 173.054);
        atomicMass.put("Lu", 174.9668);
        atomicMass.put("Hf", 178.49);
        atomicMass.put("Ta", 180.94788);
        atomicMass.put("W", 183.84);
        atomicMass.put("Re", 186.207);
        atomicMass.put("Os", 190.23);
        atomicMass.put("Ir", 192.217);
        atomicMass.put("Pt", 195.084);
        atomicMass.put("Au", 196.966569);
        atomicMass.put("Hg", 200.592);
        atomicMass.put("Tl", 204.38);
        atomicMass.put("Pb", 207.2);
        atomicMass.put("Bi", 208.98040);
        atomicMass.put("Po", 209.0);
        atomicMass.put("At", 210.0);
        atomicMass.put("Rn", 222.0);
        atomicMass.put("Fr", 223.0);
        atomicMass.put("Ra", 226.0);
        atomicMass.put("Ac", 227.0);
        atomicMass.put("Th", 232.0377);
        atomicMass.put("Pa", 231.03588);
        atomicMass.put("U", 238.02891);
        atomicMass.put("Np", 237.0);
        atomicMass.put("Pu", 244.0);
        atomicMass.put("Am", 243.0);
        atomicMass.put("Cm", 247.0);
        atomicMass.put("Bk", 247.0);
        atomicMass.put("Cf", 251.0);
        atomicMass.put("Es", 252.0);
        atomicMass.put("Fm", 257.0);
        atomicMass.put("Uue", 315.0);
        atomicMass.put("Ubn", 299.0);
    }

    private static double evaluate(String s) {
        String sym = s + "[";
        double sum = 0.0;
        StringBuilder symbol = new StringBuilder();
        String number = "";
        for (int i = 0; i < sym.length(); ++i) {
            char c = sym.charAt(i);
            if ('@' <= c && c <= '[') {
                // @, A-Z, [
                int n = 1;
                if (!number.isEmpty()) {
                    n = Integer.parseInt(number);
                }
                if (symbol.length() > 0) {
                    sum += atomicMass.getOrDefault(symbol.toString(), 0.0) * n;
                }
                if (c == '[') {
                    break;
                }
                symbol = new StringBuilder(String.valueOf(c));
                number = "";
            } else if ('a' <= c && c <= 'z') {
                symbol.append(c);
            } else if ('0' <= c && c <= '9') {
                number += c;
            } else {
                throw new RuntimeException("Unexpected symbol " + c + " in molecule");
            }
        }
        return sum;
    }

    private static String replaceParens(String s) {
        char letter = 'a';
        String si = s;
        while (true) {
            int start = si.indexOf('(');
            if (start == -1) {
                break;
            }

            for (int i = start + 1; i < si.length(); ++i) {
                if (si.charAt(i) == ')') {
                    String expr = si.substring(start + 1, i);
                    String symbol = "@" + letter;
                    String pattern = Pattern.quote(si.substring(start, i + 1));
                    si = si.replaceFirst(pattern, symbol);
                    atomicMass.put(symbol, evaluate(expr));
                    letter++;
                    break;
                }
                if (si.charAt(i) == '(') {
                    start = i;
                }
            }
        }
        return si;
    }

    public static void main(String[] args) {
        List<String> molecules = List.of(
            "H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12",
            "COOH(C(CH3)2)3CH3", "C6H4O2(OH)4", "C27H46O", "Uue"
        );
        for (String molecule : molecules) {
            double mass = evaluate(replaceParens(molecule));
            System.out.printf("%17s -> %7.3f\n", molecule, mass);
        }
    }
}
