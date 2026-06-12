pragma ada_2022;                -- When big_integers were introduced.

with ada.numerics.big_numbers.big_integers;
use ada.numerics.big_numbers.big_integers;

with ada.strings; use ada.strings;
with ada.strings.fixed; use ada.strings.fixed;
with ada.strings.unbounded; use ada.strings.unbounded;

with ada.text_io; use ada.text_io;

procedure BIVARIATE_CONTINUED_FRACTION_TASK is

  package CONTINUED_FRACTIONS is

    type memoization_storage is array (natural range <>) of big_integer;
    type memoization_access is access memoization_storage;

    type continued_fraction_record is abstract tagged
      record
        terminated : boolean := false;   -- Are there no more terms?
        memo_count : natural := 0;       -- How many terms are memoized?
        memo       : memoization_access  -- Memoized terms.
                       := new memoization_storage (0 .. 31);
      end record;

    procedure generate_term (cf : in out continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer) is abstract;

    type continued_fraction is access all
      continued_fraction_record'class; -- The 'class notation is important.

    function term_exists (cf : in continued_fraction;
                          i  : in natural)
                          return boolean;

    function get_term (cf : in continued_fraction;
                       i  : in natural)
                       return big_integer
      with pre => i < cf.memo_count;

    function cf2string (cf        : in continued_fraction;
                        max_terms : in positive := 20)
                        return unbounded_string;

  end CONTINUED_FRACTIONS;

  package body CONTINUED_FRACTIONS is

    function term_exists (cf : in continued_fraction;
                          i  : in natural)
                          return boolean is
      procedure resize_if_necessary is
        memo1 : memoization_access;
      begin
        if cf.memo'length <= i then
          memo1 := new memoization_storage(0 .. 2 * (i + 1));
          for i in 0 .. cf.memo_count - 1 loop
            memo1(i) := cf.memo(i);
          end loop;
          cf.memo := memo1;
        end if;
      end;
      exists : boolean;
      term   : big_integer;
    begin
      if i < cf.memo_count then
        exists := true;
      elsif cf.terminated then
        exists := false;
      else
        resize_if_necessary;
        while cf.memo_count <= i and not cf.terminated loop
          generate_term (cf.all, exists, term);
          if exists then
            cf.memo(cf.memo_count) := term;
            cf.memo_count := cf.memo_count + 1;
          else
            cf.terminated := true;
          end if;
        end loop;
        exists := term_exists (cf, i);
      end if;
      return exists;
    end;

    function get_term (cf : in continued_fraction;
                       i  : in natural)
                       return big_integer is
    begin
      return cf.memo(i);
    end;

    function cf2string (cf        : in continued_fraction;
                        max_terms : in positive := 20)
                        return unbounded_string is
      s    : unbounded_string := null_unbounded_string;
      done : boolean;
      i    : natural;
      term : big_integer;
    begin
      s := s & "[";
      i := 0;
      done := false;
      while not done loop
        if not term_exists (cf, i) then
          s := s & "]";
          done := true;
        elsif i = max_terms then
          s := s & ",...]";
          done := true;
        else
          if i = 1 then
            s := s & ";";
          elsif i /= 0 then
            s := s & ",";
          end if;
          term := get_term (cf, i);
          s := s & trim (term'image, left);
          i := i + 1;
        end if;
      end loop;
      return s;
    end;

  end CONTINUED_FRACTIONS;

  package CONSTANT_TERM_CONTINUED_FRACTIONS is

    use CONTINUED_FRACTIONS;

    type constant_term_continued_fraction_record is
         new continued_fraction_record with
      record
        term : big_integer;
      end record;

    type constant_term_continued_fraction is access all
      constant_term_continued_fraction_record;

    function constant_term_cf (term : in big_integer)
                              return continued_fraction;

    overriding
    procedure generate_term (cf : in out constant_term_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer);

  end CONSTANT_TERM_CONTINUED_FRACTIONS;

  package body CONSTANT_TERM_CONTINUED_FRACTIONS is

    function constant_term_cf (term : in big_integer)
                              return continued_fraction is
      cf : constant_term_continued_fraction;
    begin
      cf := new constant_term_continued_fraction_record;
      cf.term := term;
      return continued_fraction (cf);
    end;

    overriding
    procedure generate_term (cf : in out constant_term_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer) is
    begin
      output_exists := true;
      output := cf.term;
    end;

  end CONSTANT_TERM_CONTINUED_FRACTIONS;

  package INTEGER_CONTINUED_FRACTIONS is

    use CONTINUED_FRACTIONS;

    type integer_continued_fraction_record is
         new continued_fraction_record with
      record
        term : big_integer;
        done : boolean := false;
      end record;

    type integer_continued_fraction is access all
      integer_continued_fraction_record;

    function i2cf (term : in big_integer)
                   return continued_fraction;

    overriding
    procedure generate_term (cf : in out integer_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer);

  end INTEGER_CONTINUED_FRACTIONS;

  package body INTEGER_CONTINUED_FRACTIONS is

    function i2cf (term : in big_integer)
                   return continued_fraction is
      cf : integer_continued_fraction;
    begin
      cf := new integer_continued_fraction_record;
      cf.term := term;
      return continued_fraction (cf);
    end;

    overriding
    procedure generate_term (cf : in out integer_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer) is
    begin
      output_exists := not (cf.done);
      cf.done := true;
      if output_exists then
        output := cf.term;
      end if;
    end;

  end INTEGER_CONTINUED_FRACTIONS;

  package NG8_CONTINUED_FRACTIONS is

    use CONTINUED_FRACTIONS;

    stopping_processing_threshold : big_integer := 2 ** 512;
    infinitization_threshold      : big_integer := 2 ** 64;

    type ng8_continued_fraction_record is
         new continued_fraction_record with
      record
        a12, a1, a2, a : big_integer;
        b12, b1, b2, b : big_integer;
        x, y           : continued_fraction;
        ix, iy         : natural;
        xoverflow      : boolean;
        yoverflow      : boolean;
      end record;

    type ng8_continued_fraction is access all
      ng8_continued_fraction_record;

    function apply_ng8 (a12, a1, a2, a : in big_integer;
                        b12, b1, b2, b : in big_integer;
                        x, y           : in continued_fraction)
                        return continued_fraction;

    -- Addition.
    function "+" (x, y : in continued_fraction)
                  return continued_fraction;
    function "+" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction;
    function "+" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction;

    -- Keeping the same sign. (Effectively clones x as an
    -- ng8_continued_fraction.)
    function "+" (x : in continued_fraction)
                  return continued_fraction;

    -- Subtraction.
    function "-" (x, y : in continued_fraction)
                  return continued_fraction;
    function "-" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction;
    function "-" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction;

    -- Negation.
    function "-" (x : in continued_fraction)
                  return continued_fraction;

    -- Multiplication.
    function "*" (x, y : in continued_fraction)
                  return continued_fraction;
    function "*" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction;
    function "*" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction;

    -- Division.
    function "/" (x, y : in continued_fraction)
                  return continued_fraction;
    function "/" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction;
    function "/" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction;

    -- A rational number as a continued fraction. The terms are
    -- memoized, so this implementation will not be as inefficient as
    -- one might suppose.
    function r2cf (n, d : in big_integer)
                   return continued_fraction;

    overriding
    procedure generate_term (cf : in out ng8_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer);

  end NG8_CONTINUED_FRACTIONS;

  package body NG8_CONTINUED_FRACTIONS is

    use CONTINUED_FRACTIONS;
    use CONSTANT_TERM_CONTINUED_FRACTIONS;

    -- An arbitrary infinite source of non-zero finite terms.
    forever_cf : continued_fraction := constant_term_cf (1234);

    function apply_ng8 (a12, a1, a2, a : in big_integer;
                        b12, b1, b2, b : in big_integer;
                        x, y           : in continued_fraction)
                        return continued_fraction is
      cf : ng8_continued_fraction;
    begin
      cf := new ng8_continued_fraction_record;
      cf.a12 := a12;
      cf.a1  := a1;
      cf.a2  := a2;
      cf.a   := a;
      cf.b12 := b12;
      cf.b1  := b1;
      cf.b2  := b2;
      cf.b   := b;
      cf.x   := x;
      cf.y   := y;
      cf.ix  := 0;
      cf.iy  := 0;
      cf.xoverflow := false;
      cf.yoverflow := false;
      return continued_fraction (cf);
    end;

    function "+" (x, y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, 1, 0, 0, 0, 0, 1, x, y);
    end;

    function "+" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, 0, y, 0, 0, 0, 1, x, forever_cf);
    end;

    function "+" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, 1, x, 0, 0, 0, 1, forever_cf, y);
    end;

    function "+" (x : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, 1, 0, 0, 0, 0, 1, forever_cf, x);
    end;

    function "-" (x, y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, -1, 0, 0, 0, 0, 1, x, y);
    end;

    function "-" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, 0, -y, 0, 0, 0, 1, x, forever_cf);
    end;

    function "-" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, -1, x, 0, 0, 0, 1, forever_cf, y);
    end;

    function "-" (x : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, -1, 0, 0, 0, 0, 1, forever_cf, x);
    end;

    function "*" (x, y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (1, 0, 0, 0, 0, 0, 0, 1, x, y);
    end;

    function "*" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction is
    begin
      return apply_ng8 (0, y, 0, 0, 0, 0, 0, 1, x, forever_cf);
    end;

    function "*" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, x, 0, 0, 0, 0, 1, forever_cf, y);
    end;

    function "/" (x, y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, 0, 0, 0, 0, 1, 0, x, y);
    end;

    function "/" (x : in continued_fraction;
                  y : in big_integer)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 1, 0, 0, 0, 0, 0, y, x, forever_cf);
    end;

    function "/" (x : in big_integer;
                  y : in continued_fraction)
                  return continued_fraction is
    begin
      return apply_ng8 (0, 0, 0, x, 0, 0, 1, 0, forever_cf, y);
    end;

    function r2cf (n, d : in big_integer)
                   return continued_fraction is
    begin
      return apply_ng8 (0, 0, 0, n, 0, 0, 0, d, forever_cf, forever_cf);
    end;

    procedure possibly_infinitize_output (q             : in big_integer;
                                          output_exists : out boolean;
                                          output        : out big_integer) is
    begin
      output_exists := abs (q) < abs (infinitization_threshold);
      if output_exists then
        output := q;
      end if;
    end;

    procedure divide (a, b : in big_integer;
                      q, r : out big_integer) is
    begin
      if b /= 0 then
        q := a / b;
        r := a rem b;
      end if;
    end;

    function too_big (num : big_integer)
                      return boolean is
    begin
      return (abs (stopping_processing_threshold) <= abs (num));
    end;

    function any_too_big (a, b, c, d, e, f, g, h : in big_integer)
                          return boolean is
    begin
      return (too_big (a) or else
              too_big (b) or else
              too_big (c) or else
              too_big (d) or else
              too_big (e) or else
              too_big (f) or else
              too_big (g) or else
              too_big (h));
    end;

    overriding
    procedure generate_term (cf : in out ng8_continued_fraction_record;
                             output_exists : out boolean;
                             output        : out big_integer) is

      a12, a1, a2, a        : big_integer;
      b12, b1, b2, b        : big_integer;
      q12, q1, q2, q        : big_integer;
      r12, r1, r2, r        : big_integer;
      absorb_y_instead_of_x : boolean;
      done                  : boolean;

      function all_b_are_zero
               return boolean is
      begin
        return (b12 = 0 and b1 = 0 and b2 = 0 and b = 0);
      end;

      function all_q_are_equal
               return boolean is
      begin
        return (q = q1 and q = q2 and q = q12);
      end;

      procedure compare_fractions is
        n1, n2, n : big_integer;
      begin
        -- Rather than compare fractions, we will put the numerators over
        -- a common denominator of b*b1*b2, and then compare the new
        -- numerators.
        n1 := a1 * b2 * b;
        n2 := a2 * b1 * b;
        n  := a  * b1 * b2;
        absorb_y_instead_of_x := (abs (n1 - n) <= abs (n2 - n));
      end;

      procedure absorb_x_term is
        term                           : big_integer;
        new_a12, new_a1, new_a2, new_a : big_integer;
        new_b12, new_b1, new_b2, new_b : big_integer;
      begin
        new_a2 := a12;
        new_a  := a1;
        new_b2 := b12;
        new_b  := b1;
        if not cf.xoverflow and then term_exists (cf.x, cf.ix) then
          term := get_term (cf.x, cf.ix);
          new_a12 := a2 + (a12 * term);
          new_a1  := a  + (a1  * term);
          new_b12 := b2 + (b12 * term);
          new_b1  := b  + (b1  * term);
          if any_too_big (new_a12, new_a1, new_a2, new_a,
                          new_b12, new_b1, new_b2, new_b) then
            cf.xoverflow := true;
            new_a12 := a12;
            new_a1  := a1;
            new_b12 := b12;
            new_b1  := b1;
          else
            cf.ix := cf.ix + 1;
          end if;
        else
          new_a12 := a12;
          new_a1  := a1;
          new_b12 := b12;
          new_b1  := b1;
        end if;
        a12 := new_a12;
        a1  := new_a1;
        a2  := new_a2;
        a   := new_a;
        b12 := new_b12;
        b1  := new_b1;
        b2  := new_b2;
        b   := new_b;
      end;

      procedure absorb_y_term is
        term                           : big_integer;
        new_a12, new_a1, new_a2, new_a : big_integer;
        new_b12, new_b1, new_b2, new_b : big_integer;
      begin
        new_a1 := a12;
        new_a  := a2;
        new_b1 := b12;
        new_b  := b2;
        if not cf.yoverflow and then term_exists (cf.y, cf.iy) then
          term := get_term (cf.y, cf.iy);
          new_a12 := a1 + (a12 * term);
          new_a2  := a  + (a2  * term);
          new_b12 := b1 + (b12 * term);
          new_b2  := b  + (b2  * term);
          if any_too_big (new_a12, new_a1, new_a2, new_a,
                          new_b12, new_b1, new_b2, new_b) then
            cf.yoverflow := true;
            new_a12 := a12;
            new_a2  := a2;
            new_b12 := b12;
            new_b2  := b2;
          else
            cf.iy := cf.iy + 1;
          end if;
        else
          new_a12 := a12;
          new_a2  := a2;
          new_b12 := b12;
          new_b2  := b2;
        end if;
        a12 := new_a12;
        a1  := new_a1;
        a2  := new_a2;
        a   := new_a;
        b12 := new_b12;
        b1  := new_b1;
        b2  := new_b2;
        b   := new_b;
      end;

      procedure absorb_term is
      begin
        if absorb_y_instead_of_x then
          absorb_y_term;
        else
          absorb_x_term;
        end if;
      end;

    begin
      a12 := cf.a12;
      a1  := cf.a1;
      a2  := cf.a2;
      a   := cf.a;
      b12 := cf.b12;
      b1  := cf.b1;
      b2  := cf.b2;
      b   := cf.b;

      done := false;
      while not done loop
        absorb_y_instead_of_x := false;
        if all_b_are_zero then
          -- There are no more terms.
          output_exists := false;
          done := true;
        elsif b2 = 0 and b = 0 then
          null;
        elsif b2 = 0 or b = 0 then
          absorb_y_instead_of_x := true;
        elsif b1 = 0 then
          null;
        else
          divide (a12, b12, q12, r12);
          divide (a1, b1, q1, r1);
          divide (a2, b2, q2, r2);
          divide (a, b, q, r);
          if b12 /= 0 and then all_q_are_equal then
            -- Output a term.
            cf.a12 := b12;
            cf.a1  := b1;
            cf.a2  := b2;
            cf.a   := b;
            cf.b12 := r12;
            cf.b1  := r1;
            cf.b2  := r2;
            cf.b   := r;
            possibly_infinitize_output (q, output_exists, output);
            done := true;
          else
            compare_fractions;
          end if;
        end if;
        absorb_term;
      end loop;
    end;

  end NG8_CONTINUED_FRACTIONS;

  use CONTINUED_FRACTIONS;
  use CONSTANT_TERM_CONTINUED_FRACTIONS;
  use INTEGER_CONTINUED_FRACTIONS;
  use NG8_CONTINUED_FRACTIONS;

  procedure show (expression : in string;
                  cf         : in continued_fraction;
                  note       : in string := "") is
    expr     : string := 19 * ' ';
    contfrac : string := 48 * ' ';
  begin
    move (source => expression,
          target => expr,
          justify => right);
    put (expr);
    put (" =>  ");
    if note = "" then
      put_line (to_string (cf2string (cf)));
    else
      move (source => to_string (cf2string (cf)),
            target => contfrac,
            justify => left);
      put (contfrac);
      put_line (note);
    end if;
  end;

  golden_ratio : continued_fraction := constant_term_cf (1);
  silver_ratio : continued_fraction := constant_term_cf (2);
  one          : continued_fraction := i2cf (1);
  two          : continued_fraction := i2cf (2);
  three        : continued_fraction := i2cf (3);
  four         : continued_fraction := i2cf (4);
  sqrt2        : continued_fraction := silver_ratio - 1;

begin

  show ("golden ratio", golden_ratio, "(1 + sqrt(5))/2");
  show ("silver ratio", silver_ratio, "(1 + sqrt(2))");
  show ("sqrt(2)", sqrt2, "silver ratio minus 1");
  show ("13/11", r2cf (13, 11));
  show ("22/7", r2cf (22, 7), "approximately pi");
  show ("1", one);
  show ("2", two);
  show ("3", three);
  show ("4", four);
  show ("(1 + 1/sqrt(2))/2",
        apply_ng8 (0, 1, 0, 0, 0, 0, 2, 0, silver_ratio, sqrt2),
        "method 1");
  show ("(1 + 1/sqrt(2))/2",
        apply_ng8 (1, 0, 0, 1, 0, 0, 0, 8, silver_ratio, silver_ratio),
        "method 2");
  show ("(1 + 1/sqrt(2))/2",
        (one / 2) * (one + (1 / sqrt2)),
        "method 3");
  show ("sqrt(2) + sqrt(2)", sqrt2 + sqrt2);
  show ("sqrt(2) - sqrt(2)", sqrt2 - sqrt2);
  show ("sqrt(2) * sqrt(2)", sqrt2 * sqrt2);
  show ("sqrt(2) / sqrt(2)", sqrt2 / sqrt2);

end BIVARIATE_CONTINUED_FRACTION_TASK;

-- local variables:
-- mode: indented-text
-- tab-width: 2
-- end:
