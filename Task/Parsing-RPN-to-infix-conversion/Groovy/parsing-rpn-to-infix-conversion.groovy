class PostfixToInfix {
    static class Expression {
        final static String ops = "-+/*^"

        String op, ex
        int precedence = 3

        Expression(String e) {
            ex = e
        }

        Expression(String e1, String e2, String o) {
            ex = String.format "%s %s %s", e1, o, e2
            op = o
            precedence = (ops.indexOf(o) / 2) as int
        }

        @Override
        String toString() {
            return ex
        }
    }

    static String postfixToInfix(final String postfix) {
        Stack<Expression> expr = new Stack<>()

        for (String token in postfix.split("\\s+")) {
            char c = token.charAt(0)
            int idx = Expression.ops.indexOf(c as int)
            if (idx != -1 && token.length() == 1) {

                Expression r = expr.pop()
                Expression l = expr.pop()

                int opPrecedence = (idx / 2) as int

                if (l.precedence < opPrecedence || (l.precedence == opPrecedence && c == '^' as char))
                    l.ex = '(' + l.ex + ')'

                if (r.precedence < opPrecedence || (r.precedence == opPrecedence && c != '^' as char))
                    r.ex = '(' + r.ex + ')'

                expr << new Expression(l.ex, r.ex, token)
            } else {
                expr << new Expression(token)
            }
            printf "%s -> %s%n", token, expr
        }
        expr.peek().ex
    }

    static void main(String[] args) {
        (["3 4 2 * 1 5 - 2 3 ^ ^ / +", "1 2 + 3 4 + ^ 5 6 + ^"]).each { String e ->
            printf "Postfix : %s%n", e
            printf "Infix : %s%n", postfixToInfix(e)
            println()
        }
    }
}
