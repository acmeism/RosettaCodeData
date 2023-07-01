using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

static class Func {
    public static Func<T, TResult2> andThen<T, TResult, TResult2>(
            this Func<T, TResult> @this,
            Func<TResult, TResult2> after)
        => _ => after(@this(_));
}

delegate OUTPUT SelfApplicable<OUTPUT>(SelfApplicable<OUTPUT> s);
static class SelfApplicable {
    public static OUTPUT selfApply<OUTPUT>(this SelfApplicable<OUTPUT> @this) => @this(@this);
}

delegate FUNCTION FixedPoint<FUNCTION>(Func<FUNCTION, FUNCTION> f);

delegate OUTPUT VarargsFunction<INPUTS, OUTPUT>(params INPUTS[] inputs);
static class VarargsFunction {
    public static VarargsFunction<INPUTS, OUTPUT> from<INPUTS, OUTPUT>(
            Func<INPUTS[], OUTPUT> function)
        => function.Invoke;

    public static VarargsFunction<INPUTS, OUTPUT> upgrade<INPUTS, OUTPUT>(
            Func<INPUTS, OUTPUT> function) {
        return inputs => function(inputs[0]);
    }

    public static VarargsFunction<INPUTS, OUTPUT> upgrade<INPUTS, OUTPUT>(
            Func<INPUTS, INPUTS, OUTPUT> function) {
        return inputs => function(inputs[0], inputs[1]);
    }

    public static VarargsFunction<INPUTS, POST_OUTPUT> andThen<INPUTS, OUTPUT, POST_OUTPUT>(
            this VarargsFunction<INPUTS, OUTPUT> @this,
            VarargsFunction<OUTPUT, POST_OUTPUT> after) {
        return inputs => after(@this(inputs));
    }

    public static Func<INPUTS, OUTPUT> toFunction<INPUTS, OUTPUT>(
            this VarargsFunction<INPUTS, OUTPUT> @this) {
        return input => @this(input);
    }

    public static Func<INPUTS, INPUTS, OUTPUT> toBiFunction<INPUTS, OUTPUT>(
            this VarargsFunction<INPUTS, OUTPUT> @this) {
        return (input, input2) => @this(input, input2);
    }

    public static VarargsFunction<PRE_INPUTS, OUTPUT> transformArguments<PRE_INPUTS, INPUTS, OUTPUT>(
            this VarargsFunction<INPUTS, OUTPUT> @this,
            Func<PRE_INPUTS, INPUTS> transformer) {
        return inputs => @this(inputs.AsParallel().AsOrdered().Select(transformer).ToArray());
    }
}

delegate FixedPoint<FUNCTION> Y<FUNCTION>(SelfApplicable<FixedPoint<FUNCTION>> y);

static class Program {
    static TResult Cast<TResult>(this Delegate @this) where TResult : Delegate {
        return (TResult)Delegate.CreateDelegate(typeof(TResult), @this.Target, @this.Method);
    }

    static void Main(params String[] arguments) {
        BigInteger TWO = BigInteger.One + BigInteger.One;

        Func<IFormattable, long> toLong = x => long.Parse(x.ToString());
        Func<IFormattable, BigInteger> toBigInteger = x => new BigInteger(toLong(x));

        /* Based on https://gist.github.com/aruld/3965968/#comment-604392 */
        Y<VarargsFunction<IFormattable, IFormattable>> combinator = y => f => x => f(y.selfApply()(f))(x);
        FixedPoint<VarargsFunction<IFormattable, IFormattable>> fixedPoint =
            combinator.Cast<SelfApplicable<FixedPoint<VarargsFunction<IFormattable, IFormattable>>>>().selfApply();

        VarargsFunction<IFormattable, IFormattable> fibonacci = fixedPoint(
            f => VarargsFunction.upgrade(
                toBigInteger.andThen(
                    n => (IFormattable)(
                        (n.CompareTo(TWO) <= 0)
                        ? 1
                        : BigInteger.Parse(f(n - BigInteger.One).ToString())
                            + BigInteger.Parse(f(n - TWO).ToString()))
                )
            )
        );

        VarargsFunction<IFormattable, IFormattable> factorial = fixedPoint(
            f => VarargsFunction.upgrade(
                toBigInteger.andThen(
                    n => (IFormattable)((n.CompareTo(BigInteger.One) <= 0)
                        ? 1
                        : n * BigInteger.Parse(f(n - BigInteger.One).ToString()))
                )
            )
        );

        VarargsFunction<IFormattable, IFormattable> ackermann = fixedPoint(
            f => VarargsFunction.upgrade(
                (BigInteger m, BigInteger n) => m.Equals(BigInteger.Zero)
                    ? n + BigInteger.One
                    : f(
                        m - BigInteger.One,
                        n.Equals(BigInteger.Zero)
                            ? BigInteger.One
                            : f(m, n - BigInteger.One)
                    )
            ).transformArguments(toBigInteger)
        );

        var functions = new Dictionary<String, VarargsFunction<IFormattable, IFormattable>>();
        functions.Add("fibonacci", fibonacci);
        functions.Add("factorial", factorial);
        functions.Add("ackermann", ackermann);

        var parameters = new Dictionary<VarargsFunction<IFormattable, IFormattable>, IFormattable[]>();
        parameters.Add(functions["fibonacci"], new IFormattable[] { 20 });
        parameters.Add(functions["factorial"], new IFormattable[] { 10 });
        parameters.Add(functions["ackermann"], new IFormattable[] { 3, 2 });

        functions.AsParallel().Select(
            entry => entry.Key
                + "[" + String.Join(", ", parameters[entry.Value].Select(x => x.ToString())) + "]"
                + " = "
                + entry.Value(parameters[entry.Value])
        ).ForAll(Console.WriteLine);
    }
}
