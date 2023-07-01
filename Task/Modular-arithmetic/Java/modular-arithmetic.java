public class ModularArithmetic {
    private interface Ring<T> {
        Ring<T> plus(Ring<T> rhs);

        Ring<T> times(Ring<T> rhs);

        int value();

        Ring<T> one();

        default Ring<T> pow(int p) {
            if (p < 0) {
                throw new IllegalArgumentException("p must be zero or greater");
            }

            int pp = p;
            Ring<T> pwr = this.one();
            while (pp-- > 0) {
                pwr = pwr.times(this);
            }
            return pwr;
        }
    }

    private static class ModInt implements Ring<ModInt> {
        private int value;
        private int modulo;

        private ModInt(int value, int modulo) {
            this.value = value;
            this.modulo = modulo;
        }

        @Override
        public Ring<ModInt> plus(Ring<ModInt> other) {
            if (!(other instanceof ModInt)) {
                throw new IllegalArgumentException("Cannot add an unknown ring.");
            }
            ModInt rhs = (ModInt) other;
            if (modulo != rhs.modulo) {
                throw new IllegalArgumentException("Cannot add rings with different modulus");
            }
            return new ModInt((value + rhs.value) % modulo, modulo);
        }

        @Override
        public Ring<ModInt> times(Ring<ModInt> other) {
            if (!(other instanceof ModInt)) {
                throw new IllegalArgumentException("Cannot multiple an unknown ring.");
            }
            ModInt rhs = (ModInt) other;
            if (modulo != rhs.modulo) {
                throw new IllegalArgumentException("Cannot multiply rings with different modulus");
            }
            return new ModInt((value * rhs.value) % modulo, modulo);
        }

        @Override
        public int value() {
            return value;
        }

        @Override
        public Ring<ModInt> one() {
            return new ModInt(1, modulo);
        }

        @Override
        public String toString() {
            return String.format("ModInt(%d, %d)", value, modulo);
        }
    }

    private static <T> Ring<T> f(Ring<T> x) {
        return x.pow(100).plus(x).plus(x.one());
    }

    public static void main(String[] args) {
        ModInt x = new ModInt(10, 13);
        Ring<ModInt> y = f(x);
        System.out.print("x ^ 100 + x + 1 for x = ModInt(10, 13) is ");
        System.out.println(y);
        System.out.flush();
    }
}
