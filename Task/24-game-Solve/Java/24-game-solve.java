import java.util.*;

public class Game24Player {
    final String[] patterns = {"nnonnoo", "nnonono", "nnnoono", "nnnonoo",
        "nnnnooo"};
    final String ops = "+-*/^";

    String solution;
    List<Integer> digits;

    public static void main(String[] args) {
        new Game24Player().play();
    }

    void play() {
        digits = getSolvableDigits();

        Scanner in = new Scanner(System.in);
        while (true) {
            System.out.print("Make 24 using these digits: ");
            System.out.println(digits);
            System.out.println("(Enter 'q' to quit, 's' for a solution)");
            System.out.print("> ");

            String line = in.nextLine();
            if (line.equalsIgnoreCase("q")) {
                System.out.println("\nThanks for playing");
                return;
            }

            if (line.equalsIgnoreCase("s")) {
                System.out.println(solution);
                digits = getSolvableDigits();
                continue;
            }

            char[] entry = line.replaceAll("[^*+-/)(\\d]", "").toCharArray();

            try {
                validate(entry);

                if (evaluate(infixToPostfix(entry))) {
                    System.out.println("\nCorrect! Want to try another? ");
                    digits = getSolvableDigits();
                } else {
                    System.out.println("\nNot correct.");
                }

            } catch (Exception e) {
                System.out.printf("%n%s Try again.%n", e.getMessage());
            }
        }
    }

    void validate(char[] input) throws Exception {
        int total1 = 0, parens = 0, opsCount = 0;

        for (char c : input) {
            if (Character.isDigit(c))
                total1 += 1 << (c - '0') * 4;
            else if (c == '(')
                parens++;
            else if (c == ')')
                parens--;
            else if (ops.indexOf(c) != -1)
                opsCount++;
            if (parens < 0)
                throw new Exception("Parentheses mismatch.");
        }

        if (parens != 0)
            throw new Exception("Parentheses mismatch.");

        if (opsCount != 3)
            throw new Exception("Wrong number of operators.");

        int total2 = 0;
        for (int d : digits)
            total2 += 1 << d * 4;

        if (total1 != total2)
            throw new Exception("Not the same digits.");
    }

    boolean evaluate(char[] line) throws Exception {
        Stack<Float> s = new Stack<>();
        try {
            for (char c : line) {
                if ('0' <= c && c <= '9')
                    s.push((float) c - '0');
                else
                    s.push(applyOperator(s.pop(), s.pop(), c));
            }
        } catch (EmptyStackException e) {
            throw new Exception("Invalid entry.");
        }
        return (Math.abs(24 - s.peek()) < 0.001F);
    }

    float applyOperator(float a, float b, char c) {
        switch (c) {
            case '+':
                return a + b;
            case '-':
                return b - a;
            case '*':
                return a * b;
            case '/':
                return b / a;
            default:
                return Float.NaN;
        }
    }

    List<Integer> randomDigits() {
        Random r = new Random();
        List<Integer> result = new ArrayList<>(4);
        for (int i = 0; i < 4; i++)
            result.add(r.nextInt(9) + 1);
        return result;
    }

    List<Integer> getSolvableDigits() {
        List<Integer> result;
        do {
            result = randomDigits();
        } while (!isSolvable(result));
        return result;
    }

    boolean isSolvable(List<Integer> digits) {
        Set<List<Integer>> dPerms = new HashSet<>(4 * 3 * 2);
        permute(digits, dPerms, 0);

        int total = 4 * 4 * 4;
        List<List<Integer>> oPerms = new ArrayList<>(total);
        permuteOperators(oPerms, 4, total);

        StringBuilder sb = new StringBuilder(4 + 3);

        for (String pattern : patterns) {
            char[] patternChars = pattern.toCharArray();

            for (List<Integer> dig : dPerms) {
                for (List<Integer> opr : oPerms) {

                    int i = 0, j = 0;
                    for (char c : patternChars) {
                        if (c == 'n')
                            sb.append(dig.get(i++));
                        else
                            sb.append(ops.charAt(opr.get(j++)));
                    }

                    String candidate = sb.toString();
                    try {
                        if (evaluate(candidate.toCharArray())) {
                            solution = postfixToInfix(candidate);
                            return true;
                        }
                    } catch (Exception ignored) {
                    }
                    sb.setLength(0);
                }
            }
        }
        return false;
    }

    String postfixToInfix(String postfix) {
        class Expression {
            String op, ex;
            int prec = 3;

            Expression(String e) {
                ex = e;
            }

            Expression(String e1, String e2, String o) {
                ex = String.format("%s %s %s", e1, o, e2);
                op = o;
                prec = ops.indexOf(o) / 2;
            }
        }

        Stack<Expression> expr = new Stack<>();

        for (char c : postfix.toCharArray()) {
            int idx = ops.indexOf(c);
            if (idx != -1) {

                Expression r = expr.pop();
                Expression l = expr.pop();

                int opPrec = idx / 2;

                if (l.prec < opPrec)
                    l.ex = '(' + l.ex + ')';

                if (r.prec <= opPrec)
                    r.ex = '(' + r.ex + ')';

                expr.push(new Expression(l.ex, r.ex, "" + c));
            } else {
                expr.push(new Expression("" + c));
            }
        }
        return expr.peek().ex;
    }

    char[] infixToPostfix(char[] infix) throws Exception {
        StringBuilder sb = new StringBuilder();
        Stack<Integer> s = new Stack<>();
        try {
            for (char c : infix) {
                int idx = ops.indexOf(c);
                if (idx != -1) {
                    if (s.isEmpty())
                        s.push(idx);
                    else {
                        while (!s.isEmpty()) {
                            int prec2 = s.peek() / 2;
                            int prec1 = idx / 2;
                            if (prec2 >= prec1)
                                sb.append(ops.charAt(s.pop()));
                            else
                                break;
                        }
                        s.push(idx);
                    }
                } else if (c == '(') {
                    s.push(-2);
                } else if (c == ')') {
                    while (s.peek() != -2)
                        sb.append(ops.charAt(s.pop()));
                    s.pop();
                } else {
                    sb.append(c);
                }
            }
            while (!s.isEmpty())
                sb.append(ops.charAt(s.pop()));

        } catch (EmptyStackException e) {
            throw new Exception("Invalid entry.");
        }
        return sb.toString().toCharArray();
    }

    void permute(List<Integer> lst, Set<List<Integer>> res, int k) {
        for (int i = k; i < lst.size(); i++) {
            Collections.swap(lst, i, k);
            permute(lst, res, k + 1);
            Collections.swap(lst, k, i);
        }
        if (k == lst.size())
            res.add(new ArrayList<>(lst));
    }

    void permuteOperators(List<List<Integer>> res, int n, int total) {
        for (int i = 0, npow = n * n; i < total; i++)
            res.add(Arrays.asList((i / npow), (i % npow) / n, i % n));
    }
}
