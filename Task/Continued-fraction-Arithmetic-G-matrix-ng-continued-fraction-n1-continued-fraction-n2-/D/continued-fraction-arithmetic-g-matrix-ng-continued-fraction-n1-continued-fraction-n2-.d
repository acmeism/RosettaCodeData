//--------------------------------------------------------------------

import std.algorithm;
import std.bigint;
import std.conv;
import std.math;
import std.stdio;
import std.string;
import std.typecons;

//--------------------------------------------------------------------

class CF                        // Continued fraction.
{
  alias Term = BigInt;          // The type for terms.
  alias Index = size_t;         // The type for indexing terms.

  protected bool terminated;    // Are there no more terms?
  protected size_t m;           // The number of terms memoized.
  private Term[] memo;          // Memoization storage.

  static Index maxTerms = 20;   // Maximum number of terms in the
                                // string representation.

  this ()
  {
    terminated = false;
    m = 0;
    memo.length = 32;
  }

  protected Nullable!Term generate ()
  {
    // Return terms for zero. To get different terms, override this
    // method.
    auto retval = (Term(0)).nullable;
    if (m != 0)
      retval.nullify();
    return retval;
  }

  public Nullable!Term opIndex (Index i)
  {
    void update (size_t needed)
    {
      // Ensure all finite terms with indices 0 <= i < needed are
      // memoized.
      if (!terminated && m < needed)
        {
          if (memo.length < needed)
            // To reduce the frequency of reallocation, increase the
            // space to twice what might be needed right now.
            memo.length = 2 * needed;

          while (m != needed && !terminated)
            {
              auto term = generate ();
              if (!term.isNull())
                {
                  memo[m] = term.get();
                  m += 1;
                }
              else
                terminated = true;
            }
        }
    }

    update (i + 1);

    Nullable!Term retval;
    if (i < m)
      retval = memo[i].nullable;
    return retval;
  }

  public override string toString ()
  {
    static string[3] separators = ["", ";", ","];

    string s = "[";
    Index i = 0;
    bool done = false;
    while (!done)
      {
        auto term = this[i];
        if (term.isNull())
          {
            s ~= "]";
            done = true;
          }
        else if (i == maxTerms)
          {
            s ~= ",...]";
            done = true;
          }
        else
          {
            s ~= separators[(i <= 1) ? i : 2];
            s ~= to!string (term.get());
            i += 1;
          }
      }
    return s;
  }

  public CF opBinary(string op : "+") (CF other)
  {
    return new cfNG8 (ng8_add, this, other);
  }

  public CF opBinary(string op : "-") (CF other)
  {
    return new cfNG8 (ng8_sub, this, other);
  }

  public CF opBinary(string op : "*") (CF other)
  {
    return new cfNG8 (ng8_mul, this, other);
  }

  public CF opBinary(string op : "/") (CF other)
  {
    return new cfNG8 (ng8_div, this, other);
  }

};

//--------------------------------------------------------------------

class cfIndexed : CF  // Continued fraction with an index-to-term map.
{
  alias Mapper = Nullable!Term delegate (Index);

  protected Mapper map;

  this (Mapper map)
  {
    this.map = map;
  }

  protected override Nullable!Term generate ()
  {
    return map (m);
  }
}

__gshared goldenRatio =
  new cfIndexed ((i) => CF.Term(1).nullable);

__gshared silverRatio =
  new cfIndexed ((i) => CF.Term(2).nullable);

__gshared sqrt2 =
  new cfIndexed ((i) => CF.Term(min (i + 1, 2)).nullable);

//--------------------------------------------------------------------

class cfRational : CF           // CF for a rational number.
{
  private Term n;
  private Term d;

  this (Term numer, Term denom = Term(1))
  {
    n = numer;
    d = denom;
  }

  protected override Nullable!Term generate ()
  {
    Nullable!Term term;
    if (d != 0)
      {
        auto q = n / d;
        auto r = n % d;
        n = d;
        d = r;
        term = q.nullable;
      }
    return term;
  }
}

__gshared frac_13_11 = new cfRational (CF.Term(13), CF.Term(11));
__gshared frac_22_7 = new cfRational (CF.Term(22), CF.Term(7));
__gshared one = new cfRational (CF.Term(1));
__gshared two = new cfRational (CF.Term(2));
__gshared three = new cfRational (CF.Term(3));
__gshared four = new cfRational (CF.Term(4));

//--------------------------------------------------------------------

class NG8                       // Bihomographic function.
{
  public CF.Term a12, a1, a2, a;
  public CF.Term b12, b1, b2, b;

  this (CF.Term a12, CF.Term a1, CF.Term a2, CF.Term a,
        CF.Term b12, CF.Term b1, CF.Term b2, CF.Term b)
  {
    this.a12 = a12;
    this.a1 = a1;
    this.a2 = a2;
    this.a = a;
    this.b12 = b12;
    this.b1 = b1;
    this.b2 = b2;
    this.b = b;
  }

  this (long a12, long a1, long a2, long a,
        long b12, long b1, long b2, long b)
  {
    this.a12 = a12;
    this.a1 = a1;
    this.a2 = a2;
    this.a = a;
    this.b12 = b12;
    this.b1 = b1;
    this.b2 = b2;
    this.b = b;
  }

  this (NG8 other)
  {
    this.a12 = other.a12;
    this.a1 = other.a1;
    this.a2 = other.a2;
    this.a = other.a;
    this.b12 = other.b12;
    this.b1 = other.b1;
    this.b2 = other.b2;
    this.b = other.b;
  }
}

class cfNG8 : CF   // CF that is a bihomographic function of other CF.
{
  private NG8 ng;
  private CF x;
  private CF y;
  private Index ix;
  private Index iy;
  private bool xoverflow;
  private bool yoverflow;

  //
  // Thresholds chosen merely for demonstration.
  //
  static number_that_is_too_big = // 2 ** 512
    BigInt ("13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084096");
  static practically_infinite = // 2 ** 64
    BigInt ("18446744073709551616");

  this (NG8 ng, CF x, CF y)
  {
    this.ng = new NG8 (ng);
    this.x = x;
    this.y = y;
    ix = 0;
    iy = 0;
    xoverflow = false;
    yoverflow = false;
  }

  protected override Nullable!Term generate ()
  {
    // The McCabe complexity of this function is high. Please be
    // careful if modifying the code.

    Nullable!Term term;

    bool done = false;
    while (!done)
      {
        bool bz = (ng.b == 0);
        bool b1z = (ng.b1 == 0);
        bool b2z = (ng.b2 == 0);
        bool b12z = (ng.b12 == 0);
        if (bz && b1z && b2z && b12z)
          done = true;          // There are no more terms.
        else if (bz && b2z)
          absorb_x_term ();
        else if (bz || b2z)
          absorb_y_term ();
        else if (b1z)
          absorb_x_term ();
        else
          {
            Term q, r;
            Term q1, r1;
            Term q2, r2;
            Term q12, r12;
            divMod (ng.a, ng.b, q, r);
            divMod (ng.a1, ng.b1, q1, r1);
            divMod (ng.a2, ng.b2, q2, r2);
            if (ng.b12 != 0)
              divMod (ng.a12, ng.b12, q12, r12);
            if (!b12z && q == q1 && q == q2 && q == q12)
              {
                // Output a term.
                ng = new NG8 (ng.b12, ng.b1, ng.b2, ng.b,
                              r12, r1, r2, r);
                if (!treat_as_infinite (q))
                  term = q.nullable;
                done = true;
              }
            else
              {
                //
                // Rather than compare fractions, we will put the
                // numerators over a common denominator of b*b1*b2,
                // and then compare the new numerators.
                //
                Term n = ng.a * ng.b1 * ng.b2;
                Term n1 = ng.a1 * ng.b * ng.b2;
                Term n2 = ng.a2 * ng.b * ng.b1;
                if (abs (n1 - n) > abs (n2 - n))
                  absorb_x_term ();
                else
                  absorb_y_term ();
              }
          }
      }

    return term;
  }

  private void absorb_x_term ()
  {
    Nullable!Term term;
    if (!xoverflow)
      term = x[ix];
    ix += 1;
    if (!term.isNull())
      {
        auto t = term.get();
        auto new_ng = new NG8 (ng.a2 + (ng.a12 * t),
                               ng.a + (ng.a1 * t),
                               ng.a12, ng.a1,
                               ng.b2 + (ng.b12 * t),
                               ng.b + (ng.b1 * t),
                               ng.b12, ng.b1);
        if (!too_big (new_ng))
          ng = new_ng;
        else
          {
            ng = new NG8 (ng.a12, ng.a1, ng.a12, ng.a1,
                          ng.b12, ng.b1, ng.b12, ng.b1);
            xoverflow = true;
          }
      }
    else
      ng = new NG8 (ng.a12, ng.a1, ng.a12, ng.a1,
                    ng.b12, ng.b1, ng.b12, ng.b1);
  }

  private void absorb_y_term ()
  {
    Nullable!Term term;
    if (!yoverflow)
      term = y[iy];
    iy += 1;
    if (!term.isNull())
      {
        auto t = term.get();
        auto new_ng = new NG8 (ng.a1 + (ng.a12 * t), ng.a12,
                               ng.a + (ng.a2 * t), ng.a2,
                               ng.b1 + (ng.b12 * t), ng.b12,
                               ng.b + (ng.b2 * t), ng.b2);
        if (!too_big (new_ng))
          ng = new_ng;
        else
          {
            ng = new NG8 (ng.a12, ng.a12, ng.a2, ng.a2,
                          ng.b12, ng.b12, ng.b2, ng.b2);
            yoverflow = true;
          }
      }
    else
      ng = new NG8 (ng.a12, ng.a12, ng.a2, ng.a2,
                    ng.b12, ng.b12, ng.b2, ng.b2);
  }

  private bool too_big (NG8 ng)
  {
    // Stop computing if a number reaches the threshold.
    return (too_big (ng.a12) || too_big (ng.a1) ||
            too_big (ng.a2) || too_big (ng.a) ||
            too_big (ng.b12) || too_big (ng.b1) ||
            too_big (ng.b2) || too_big (ng.b));
  }

  private bool too_big (Term u)
  {
    return (abs (u) >= abs (number_that_is_too_big));
  }

  private bool treat_as_infinite (Term u)
  {
    return (abs(u) >= abs (practically_infinite));
  }
}

__gshared NG8 ng8_add = new NG8 (0, 1, 1, 0, 0, 0, 0, 1);
__gshared NG8 ng8_sub = new NG8 (0, 1, -1, 0, 0, 0, 0, 1);
__gshared NG8 ng8_mul = new NG8 (1, 0, 0, 0, 0, 0, 0, 1 );
__gshared NG8 ng8_div = new NG8 (0, 1, 0, 0, 0, 0, 1, 0);

//--------------------------------------------------------------------

void
show (string expression, CF cf, string note = "")
{
  auto line = rightJustify (expression, 19) ~ " =>  ";
  auto cf_str = to!string (cf);
  if (note == "")
    line ~= cf_str;
  else
    line ~= leftJustify (cf_str, 48) ~ note;
  writeln (line);
}

int
main (char[][] args)
{
  show ("golden ratio", goldenRatio, "(1 + sqrt(5))/2");
  show ("silver ratio", silverRatio, "1 + sqrt(2)");
  show ("sqrt(2)", sqrt2);
  show ("13/11", frac_13_11);
  show ("22/7", frac_22_7);
  show ("one", one);
  show ("two", two);
  show ("three", three);
  show ("four", four);
  show ("(1 + 1/sqrt(2))/2",
        new cfNG8 (new NG8 (0, 1, 0, 0, 0, 0, 2, 0),
                   silverRatio, sqrt2),
        "method 1");
  show ("(1 + 1/sqrt(2))/2",
        new cfNG8 (new NG8 (1, 0, 0, 1, 0, 0, 0, 8),
                   silverRatio, silverRatio),
        "method 2");
  show ("(1 + 1/sqrt(2))/2", (one + (one / sqrt2)) / two,
        "method 3");
  show ("sqrt(2) + sqrt(2)", sqrt2 + sqrt2);
  show ("sqrt(2) - sqrt(2)", sqrt2 - sqrt2);
  show ("sqrt(2) * sqrt(2)", sqrt2 * sqrt2);
  show ("sqrt(2) / sqrt(2)", sqrt2 / sqrt2);

  return 0;
}

//--------------------------------------------------------------------
