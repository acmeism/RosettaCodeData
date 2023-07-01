import std.conv;
import std.stdio;

alias index_t = uint; // The type for indexing terms of a continued
                      // fraction.

alias integer = long;   // The type for terms of a continued fraction.

class cf_t    //  A continued fraction, with memoization of its terms.
{
  protected bool terminated;   // Are there more terms to be memoized?
  protected index_t m;         // How many terms are memoized so far?
  private integer[] memo;      // Memoized terms.

  public index_t maxTerms = 20; // Maximum number of terms in the
                                // string representation.

  this ()
  {
    terminated = false;
    m = 0;
    memo.length = 8;
  }

  protected void generate (ref bool termExists, ref integer term)
  {
    // Return terms for zero. To get different terms, override this
    // method. (I am used to using a closure or similar for the
    // generator, and not having to derive a new continued fraction
    // type, to have a new kind of generator. However, I am trying to
    // do what is more natural within the programming language.)
    termExists = (m == 0);
    term = 0;
  }

  public void getAt (index_t i, ref bool termExists, ref integer term)
  {
    void memoizeMoreTerms (index_t needed)
    {
      while (m != needed && !terminated)
        {
          bool termExists;
          integer term;
          generate (termExists, term);
          if (termExists)
            {
              memo[m] = term;
              m += 1;
            }
          else
            terminated = true;
        }
    }

    void update (index_t needed)
    {
      // If necessary, memoize more terms, perhaps increasing the
      // space in which to store them.
      if (!terminated && m < needed)
        {
          if (memo.length < needed)
            {
              // Increase the space to twice what might be needed
              // right now.
              memo.length = 2 * needed;
            }
          memoizeMoreTerms (needed);
        }
    }

    update (i + 1);
    termExists = (i < m);
    if (termExists)
      term = memo[i];
  }

  public override string toString ()
  {
    string s = "[";
    int sep = 0;
    index_t i = 0;
    bool done = false;
    while (!done)
      {
        if (i == maxTerms)
          {
            s ~= ",...]";
            done = true;
          }
        else
          {
            bool termExists;
            integer term;
            getAt (i, termExists, term);
            if (termExists)
              {
                final switch (sep)
                  {
                  case 0 :
                    sep = 1;
                    break;
                  case 1 :
                    s ~= ";";
                    sep = 2;
                    break;
                  case 2 :
                    s ~= ",";
                    break;
                  }
                s ~= to!string (term);
                i += 1;
              }
            else
              {
                s ~= "]";
                done = true;
              }
          }
      }
    return s;
  }
}

class cfSqrt2_t : cf_t          // A continued fraction for sqrt(2).
{
  override final void generate (ref bool termExists, ref integer term)
  {
    termExists = true;
    term = (m == 0 ? 1 : 2);
  }
}

class cfRational : cf_t // A continued fraction for a rational number.
{
  private integer n;            // Numerator.
  private integer d;            // Denominator.

  this (integer numerator, integer denominator)
  {
    assert (denominator != 0);
    n = numerator;
    d = denominator;
  }

  override void generate (ref bool termExists, ref integer term)
  {
    termExists = (d != 0);
    if (termExists)
      {
        auto q = n / d;
        auto r = n % d;
        n = d;
        d = r;
        term = q;
      }
  }
}

class hfunc_t                   // A homographic function.
{
  public integer a1;
  public integer a;
  public integer b1;
  public integer b;

  this (integer a1, integer a, integer b1, integer b)
  {
    this.a1 = a1;
    this.a = a;
    this.b1 = b1;
    this.b = b;
  }
}

class cfHfunc_t : cf_t // A continued fraction that is a homographic
                       // function of some other continued fraction.
{
  private integer a1;
  private integer a;
  private integer b1;
  private integer b;
  private cf_t gen;
  private index_t index;

  this (hfunc_t hfunc, cf_t gen)
  {
    a1 = hfunc.a1;
    a = hfunc.a;
    b1 = hfunc.b1;
    b = hfunc.b;
    this.gen = gen;
    index = 0;
  }

  override void generate (ref bool termExists, ref integer term)
  {
    bool done = false;
    while (!done)
      {
        if (b1 == 0 && b == 0)
          {
            termExists = false;
            done = true;
          }
        else if (b1 != 0 && b != 0)
          {
            auto q1 = a1 / b1;
            auto q = a / b;
            if (q1 == q)
              {
                const a1_ = a1;
                const a_ = a;
                const b1_ = b1;
                const b_ = b;
                a1 = b1_;
                a = b_;
                b1 = a1_ - (b1_ * q);
                b = a_ - (b_ * q);
                termExists = true;
                term = q;
                done = true;
              }
          }

        if (!done)
          {
            gen.getAt (index, termExists, term);
            index += 1;
            if (termExists)
              {
                const a1_ = a1;
                const a_ = a;
                const b1_ = b1;
                const b_ = b;
                a1 = a_ + (a1_ * term);
                a = a1_;
                b1 = b_ + (b1_ * term);
                b = b1_;
              }
            else
              {
                a = a1;
                b = b1;
              }
          }
      }
  }
}

int
main (char[][] args)
{
  auto hf_cf_add_1_2 = new hfunc_t (2, 1, 0, 2);
  auto hf_cf_div_2 = new hfunc_t (1, 0, 0, 2);
  auto hf_cf_div_4 = new hfunc_t (1, 0, 0, 4);
  auto hf_1_div_cf = new hfunc_t (0, 1, 1, 0);

  auto cf_13_11 = new cfRational (13, 11);
  auto cf_22_7 = new cfRational (22, 7);
  auto cf_sqrt2 = new cfSqrt2_t ();

  auto cf_13_11_add_1_2 = new cfHfunc_t (hf_cf_add_1_2, cf_13_11);
  auto cf_22_7_add_1_2 = new cfHfunc_t (hf_cf_add_1_2, cf_22_7);
  auto cf_22_7_div_4 = new cfHfunc_t (hf_cf_div_4, cf_22_7);
  auto cf_sqrt2_div_2 = new cfHfunc_t (hf_cf_div_2, cf_sqrt2);
  auto cf_1_div_sqrt2 = new cfHfunc_t (hf_1_div_cf, cf_sqrt2);
  auto cf_2_add_sqrt2__div_4 =
    new cfHfunc_t (new hfunc_t (1, 2, 0, 4), cf_sqrt2);
  auto cf_1_add_1_div_sqrt2__div_2 =
    new cfHfunc_t (new hfunc_t (1, 1, 0, 2), cf_1_div_sqrt2);
  auto cf_sqrt2_div_4_add_1_2 =
    new cfHfunc_t (hf_cf_add_1_2,
                   new cfHfunc_t (hf_cf_div_4, cf_sqrt2));

  void show (string expr, cf_t cf)
  {
    writeln (expr, cf.toString());
  }

  show ("13/11 => ", cf_13_11);
  show ("22/7 => ", cf_22_7);
  show ("sqrt(2) => ", cf_sqrt2);
  show ("13/11 + 1/2 => ", cf_13_11_add_1_2);
  show ("22/7 + 1/2 => ", cf_22_7_add_1_2);
  show ("(22/7)/4 => ", cf_22_7_div_4);
  show ("sqrt(2)/2 => ", cf_sqrt2_div_2);
  show ("1/sqrt(2) => ", cf_1_div_sqrt2);
  show ("(2 + sqrt(2))/4 => ", cf_2_add_sqrt2__div_4);
  show ("(1 + 1/sqrt(2))/2 => ", cf_1_add_1_div_sqrt2__div_2);
  show ("sqrt(2)/4 + 1/2 => ", cf_sqrt2_div_4_add_1_2);
  show ("(sqrt(2)/2)/2 + 1/2 => ",
           new cfHfunc_t (hf_cf_add_1_2,
                          new cfHfunc_t (hf_cf_div_2,
                                         cf_sqrt2_div_2)));

  // Demonstrate a deeper nesting of anonymous cf_t.
  show ("(1/sqrt(2))/2 + 1/2 => ",
        new cfHfunc_t (hf_cf_add_1_2,
                       new cfHfunc_t (hf_cf_div_2,
                                      new cfHfunc_t (hf_1_div_cf,
                                                     cf_sqrt2))));

  return 0;
}
