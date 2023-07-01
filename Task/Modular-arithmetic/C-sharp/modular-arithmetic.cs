using System;

namespace ModularArithmetic {
    interface IAddition<T> {
        T Add(T rhs);
    }
    interface IMultiplication<T> {
        T Multiply(T rhs);
    }
    interface IPower<T> {
        T Power(int pow);
    }
    interface IOne<T> {
        T One();
    }

    class ModInt : IAddition<ModInt>, IMultiplication<ModInt>, IPower<ModInt>, IOne<ModInt> {
        private int modulo;

        public ModInt(int value, int modulo) {
            Value = value;
            this.modulo = modulo;
        }

        public int Value { get; }

        public ModInt One() {
            return new ModInt(1, modulo);
        }

        public ModInt Add(ModInt rhs) {
            return this + rhs;
        }

        public ModInt Multiply(ModInt rhs) {
            return this * rhs;
        }

        public ModInt Power(int pow) {
            return Pow(this, pow);
        }

        public override string ToString() {
            return string.Format("ModInt({0}, {1})", Value, modulo);
        }

        public static ModInt operator +(ModInt lhs, ModInt rhs) {
            if (lhs.modulo != rhs.modulo) {
                throw new ArgumentException("Cannot add rings with different modulus");
            }
            return new ModInt((lhs.Value + rhs.Value) % lhs.modulo, lhs.modulo);
        }

        public static ModInt operator *(ModInt lhs, ModInt rhs) {
            if (lhs.modulo != rhs.modulo) {
                throw new ArgumentException("Cannot add rings with different modulus");
            }
            return new ModInt((lhs.Value * rhs.Value) % lhs.modulo, lhs.modulo);
        }

        public static ModInt Pow(ModInt self, int p) {
            if (p < 0) {
                throw new ArgumentException("p must be zero or greater");
            }

            int pp = p;
            ModInt pwr = self.One();
            while (pp-- > 0) {
                pwr *= self;
            }
            return pwr;
        }
    }

    class Program {
        static T F<T>(T x) where T : IAddition<T>, IMultiplication<T>, IPower<T>, IOne<T> {
            return x.Power(100).Add(x).Add(x.One());
        }

        static void Main(string[] args) {
            ModInt x = new ModInt(10, 13);
            ModInt y = F(x);
            Console.WriteLine("x ^ 100 + x + 1 for x = {0} is {1}", x, y);
        }
    }
}
