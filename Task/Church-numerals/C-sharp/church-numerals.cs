using System;

public delegate Church Church(Church f);

public static class ChurchNumeral
{
    public static readonly Church ChurchZero = _ => x => x;
    public static readonly Church ChurchOne = f => f;

    public static Church Successor(this Church n) => f => x => f(n(f)(x));
    public static Church Add(this Church m, Church n) => f => x => m(f)(n(f)(x));
    public static Church Multiply(this Church m, Church n) => f => m(n(f));
    public static Church Exponent(this Church m, Church n) => n(m);
    public static Church IsZero(this Church n) => n(_ => ChurchZero)(ChurchOne);
    public static Church Predecessor(this Church n) =>
      f => x => n(g => h => h(g(f)))(_ => x)(a => a);
    public static Church Subtract(this Church m, Church n) => n(Predecessor)(m);
    static Church looper(this Church v, Church d) =>
        v(_ => v.divr(d).Successor())(ChurchZero);
    static Church divr(this Church n, Church d) =>
        n.Subtract(d).looper(d);
    public static Church Divide(this Church dvdnd, Church dvsr) =>
        (dvdnd.Successor()).divr(dvsr);

    public static Church FromInt(int i) =>
      i <= 0 ? ChurchZero : Successor(FromInt(i - 1));

    public static int ToInt(this Church ch) {
        int count = 0;
        ch(x => { count++; return x; })(null);
        return count;
    }

    public static void Main() {
        Church c3 = FromInt(3);
        Church c4 = c3.Successor();
        Church c11 = FromInt(11);
        Church c12 = c11.Successor();
        int sum = c3.Add(c4).ToInt();
        int product = c3.Multiply(c4).ToInt();
        int exp43 = c4.Exponent(c3).ToInt();
        int exp34 = c3.Exponent(c4).ToInt();
        int tst0 = ChurchZero.IsZero().ToInt();
        int pred4 = c4.Predecessor().ToInt();
        int sub43 = c4.Subtract(c3).ToInt();
        int div11by3 = c11.Divide(c3).ToInt();
        int div12by3 = c12.Divide(c3).ToInt();
        Console.Write($"{sum} {product} {exp43} {exp34} {tst0} ");
        Console.WriteLine($"{pred4} {sub43} {div11by3} {div12by3}");
    }
}
