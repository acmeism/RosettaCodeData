public class Task {
    enum Color { R, B }
    sealed interface Tree<A extends Comparable<A>> permits E, T {
        default Tree<A> insert(A a) {
            return switch(ins(a)) {
                case T(_, var l, var v, var r) -> new T<>(Color.B, l, v, r);
                case E() -> new E<>();
            };
        }

        Tree<A> ins(A a);
    }

    record E<A extends Comparable<A>>() implements Tree<A> {
        @Override
        public Tree<A> ins(A a) {
            return new T<>(Color.R, new E<>(), a, new E<>());
        }

        @Override
        public String toString() { return "E"; }
    }

    record T<A extends Comparable<A>>(Color color, Tree<A> left,
                                      A value, Tree<A> right) implements Tree<A> {
        @Override
        public Tree<A> ins(A a) {
            return switch(Integer.valueOf(a.compareTo(value))) {
                case Integer i when i < 0 -> new T<>(color, left.ins(a), value, right).balance();
                case Integer i when i > 0 -> new T<>(color, left, value, right.ins(a)).balance();
                default -> this;
            };
        }

        private Tree<A> balance() {
            if (color == Color.R) return this;
            return switch (this) {
                // unnamed patterns (case T<A>(_, ...)) are a JDK21 Preview feature
                case T<A>(_, T<A>(_, T<A>(_, var a, var x, var b), var y, var c), var z, var d)
                        when left instanceof T<A> le && le.left instanceof T<A> le_le &&
                             le.color == Color.R && le_le.color == Color.R ->
                                new T<>(Color.R, new T<>(Color.B, a, x, b), y, new T<>(Color.B, c, z, d));
                case T<A>(_, T<A>(_, var a, var x, T<A>(_, var b, var y, var c)), var z, var d)
                        when left instanceof T<A> le && le.right instanceof T<A> le_ri &&
                             le.color == Color.R && le_ri.color == Color.R ->
                                new T<>(Color.R, new T<>(Color.B, a, x, b), y, new T<>(Color.B, c, z, d));
                case T<A>(_, var a, var x, T<A>(_, T<A>(_, var b, var y, var c), var z, var d))
                        when right instanceof T<A> ri && ri.left instanceof T<A> ri_le &&
                             ri.color == Color.R && ri_le.color == Color.R ->
                                new T<>(Color.R, new T<>(Color.B, a, x, b), y, new T<>(Color.B, c, z, d));
                case T<A>(_, var a, var x, T<A>(_, var b, var y, T<A>(_, var c, var z, var d)))
                        when right instanceof T<A> ri && ri.right instanceof T<A> ri_ri &&
                             ri.color == Color.R && ri_ri.color == Color.R ->
                                new T<>(Color.R, new T<>(Color.B, a, x, b), y, new T<>(Color.B, c, z, d));
                default -> this;
            };
        }

        @Override
        public String toString() {
            return STR."T[\{color}, \{left}, \{value}, \{right}]"; // String templates are a JDK 21 Preview feature
        }
    }

    public static void main(String[] args) {
        Tree<Integer> tree = new E<>();
        for (var i : IntStream.rangeClosed(1, 16).toArray()) {
            tree = tree.insert(i);
        }
        System.out.println(tree);
    }
}
