----------------------------------------------------------------------

with ada.text_io; use ada.text_io;
with ada.strings; use ada.strings;
with ada.strings.fixed; use ada.strings.fixed;

with ada.unchecked_deallocation;

procedure univariate_continued_fraction_task is

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
-- A generator is a tree structure, accessed by a generator_t.

type generator_record;
type generator_t is access generator_record;

type generator_list_node;
type generator_list_t is access generator_list_node;

type generator_list_node is
  record
    car : generator_t;
    cdr : generator_list_t;
  end record;

type generator_workspace is array (natural range <>) of integer;
type generator_worksp_t is access generator_workspace;

type generator_proc_t is
  access procedure (workspace   : in generator_worksp_t;
                    sources     : in generator_list_t;
                    term_exists : out boolean;
                    term        : out integer);

type generator_record is
  record
    run       : generator_proc_t;   -- What does the work.
    worksize  : natural;            -- The size of workspace.
    initial   : generator_worksp_t; -- The initial value of workspace.
    workspace : generator_worksp_t; -- The workspace.
    sources   : generator_list_t;   -- The sources of input terms.
  end record;

procedure free_generator_workspace is
  new ada.unchecked_deallocation (generator_workspace,
                                  generator_worksp_t);

procedure free_generator_list_node is
  new ada.unchecked_deallocation (generator_list_node,
                                  generator_list_t);

procedure free_generator_record is
  new ada.unchecked_deallocation (generator_record,
                                  generator_t);

procedure initialize_workspace (gen : in generator_t) is
begin
  for i in 0 .. gen.worksize - 1 loop
    gen.workspace(i) := gen.initial(i);
  end loop;
end initialize_workspace;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

-- Re-initialize a generator for a computation.
procedure initialize_generator_t (gen : in generator_t) is
  p : generator_list_t;
begin
  if gen /= null then
    initialize_workspace (gen);

    p := gen.sources;
    while p /= null loop
      initialize_generator_t (p.car);
      p := p.cdr;
    end loop;
  end if;
end initialize_generator_t;

-- Free the storage of a generator.
procedure free_generator_t (gen : in out generator_t) is
  p, q : generator_list_t;
begin
  if gen /= null then
    free_generator_workspace (gen.initial);
    free_generator_workspace (gen.workspace);

    p := gen.sources;
    while p /= null loop
      q := p.cdr;
      free_generator_t (p.car);
      free_generator_list_node (p);
      p := q;
    end loop;

    free_generator_record (gen);
  end if;
end free_generator_t;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

-- Run a generator and print its output.
procedure put_generator_output (gen       : in generator_t;
                                max_terms : in positive) is
  sep         : integer range 0 .. 2;
  terms_count : natural;
  term_exists : boolean;
  term        : integer;
  done        : boolean;
begin
  initialize_generator_t (gen);

  terms_count := 0;
  sep := 0;
  done := false;
  while not done loop
    if terms_count = max_terms then
      put (",...]");
      done := true;
    else
      gen.run (gen.workspace, gen.sources, term_exists, term);
      if term_exists then
        case sep is
          when 0 =>
            put ("[");
            sep := 1;
          when 1 =>
            put (";");
            sep := 2;
          when 2 =>
            put (",");
        end case;
        put (trim (integer'image (term), left));
        terms_count := terms_count + 1;
      else
        put ("]");
        done := true;
      end if;
    end if;
  end loop;

  initialize_generator_t (gen);
end put_generator_output;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
-- Generators for continued fraction terms of rational numbers.

procedure r2cf_run (workspace   : in generator_worksp_t;
                    sources     : in generator_list_t;
                    term_exists : out boolean;
                    term        : out integer) is
  n, d, q, r : integer;
begin
  d := workspace(1);
  term_exists := (d /= 0);
  if term_exists then
    n := workspace(0);

    -- We shall use the kind of integer division that is most
    -- "natural" in Ada: truncation towards zero.
    q := n / d;                 -- Truncation towards zero.
    r := n rem d;               -- The remainder may be negative.

    workspace(0) := d;
    workspace(1) := r;

    term := q;
  end if;
end r2cf_run;

-- Make a generator for the fraction n/d.
function r2cf_make (n : in integer;
                    d : in integer)
return generator_t is
  gen : generator_t := new generator_record;
begin
  gen.run := r2cf_run'access;
  gen.worksize := 2;
  gen.initial := new generator_workspace(0 .. gen.worksize - 1);
  gen.workspace := new generator_workspace(0 .. gen.worksize - 1);
  gen.initial(0) := n;
  gen.initial(1) := d;
  initialize_workspace (gen);
  gen.sources := null;
  return gen;
end r2cf_make;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
-- A generator for continued fraction terms of sqrt(2).

procedure sqrt2_run (workspace   : in generator_worksp_t;
                     sources     : in generator_list_t;
                     term_exists : out boolean;
                     term        : out integer) is
begin
  term_exists := true;
  term := workspace(0);
  workspace(0) := 2;
end sqrt2_run;

-- Make a generator for the fraction n/d.
function sqrt2_make
return generator_t is
  gen : generator_t := new generator_record;
begin
  gen.run := sqrt2_run'access;
  gen.worksize := 1;
  gen.initial := new generator_workspace(0 .. gen.worksize - 1);
  gen.workspace := new generator_workspace(0 .. gen.worksize - 1);
  gen.initial(0) := 1;
  initialize_workspace (gen);
  gen.sources := null;
  return gen;
end sqrt2_make;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
-- Generators for the application of homographic functions to other
-- generators.

procedure hfunc_take_term (workspace : in generator_worksp_t;
                           sources   : in generator_list_t) is
  term_exists1 : boolean;
  term1        : integer;
  src          : generator_t := sources.car;
  a1, a, b1, b : integer;
begin
  src.run (src.workspace, src.sources, term_exists1, term1);
  a1 := workspace(0);
  b1 := workspace(2);
  if term_exists1 then
    a := workspace(1);
    b := workspace(3);
    workspace(0) := a + (a1 * term1);
    workspace(1) := a1;
    workspace(2) := b + (b1 * term1);
    workspace(3) := b1;
  else
    workspace(1) := a1;
    workspace(3) := b1;
  end if;
end hfunc_take_term;

procedure hfunc_run (workspace   : in generator_worksp_t;
                     sources     : in generator_list_t;
                     term_exists : out boolean;
                     term        : out integer) is
  done         : boolean;
  a1, a, b1, b : integer;
  q1, q        : integer;
begin
  done := false;
  while not done loop
    b1 := workspace(2);
    b := workspace(3);
    if b1 = 0 and b = 0 then
      term_exists := false;
      done := true;
    else
      a1 := workspace(0);
      a := workspace(1);
      if b1 /= 0 and b /= 0 then
        q1 := a1 / b1;
        q := a / b;
        if q1 = q then
          workspace(0) := b1;
          workspace(1) := b;
          workspace(2) := a1 - (b1 * q);
          workspace(3) := a - (b * q);
          term_exists := true;
          term := q;
          done := true;
        else
          hfunc_take_term (workspace, sources);
        end if;
      else
        hfunc_take_term (workspace, sources);
      end if;
    end if;
  end loop;
end hfunc_run;

function hfunc_make (a1     : in integer;
                     a      : in integer;
                     b1     : in integer;
                     b      : in integer;
                     source : in generator_t)
return generator_t is
  gen : generator_t := new generator_record;
begin
  gen.run := hfunc_run'access;
  gen.worksize := 4;
  gen.initial := new generator_workspace(0 .. gen.worksize - 1);
  gen.workspace := new generator_workspace(0 .. gen.worksize - 1);
  gen.initial(0) := a1;
  gen.initial(1) := a;
  gen.initial(2) := b1;
  gen.initial(3) := b;
  initialize_workspace (gen);
  gen.sources := new generator_list_node;
  gen.sources.car := source;
  gen.sources.cdr := null;
  return gen;
end hfunc_make;

--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

max_terms : constant positive := 20;

procedure run_gen (expr : in string;
                   gen  : in generator_t) is
begin
  put (expr);
  put (" => ");
  put_generator_output (gen, max_terms);
  put_line ("");
end run_gen;

gen : generator_t;

begin

  gen := r2cf_make (13, 11);
  run_gen ("13/11", gen);
  free_generator_t (gen);

  gen := r2cf_make (22, 7);
  run_gen ("22/7", gen);
  free_generator_t (gen);

  gen := sqrt2_make;
  run_gen ("sqrt(2)", gen);
  free_generator_t (gen);

  gen := hfunc_make (2, 1, 0, 2, r2cf_make (13, 11));
  run_gen ("13/11 + 1/2", gen);
  free_generator_t (gen);

  gen := hfunc_make (2, 1, 0, 2, r2cf_make (22, 7));
  run_gen ("22/7 + 1/2", gen);
  free_generator_t (gen);

  gen := hfunc_make (1, 0, 0, 4, r2cf_make (22, 7));
  run_gen ("(22/7)/4", gen);
  free_generator_t (gen);

  gen := hfunc_make (1, 0, 0, 2, sqrt2_make);
  run_gen ("sqrt(2)/2", gen);
  free_generator_t (gen);

  gen := hfunc_make (0, 1, 1, 0, sqrt2_make);
  run_gen ("1/sqrt(2)", gen);
  free_generator_t (gen);

  gen := hfunc_make (1, 2, 0, 4, sqrt2_make);
  run_gen ("(2 + sqrt(2))/4", gen);
  free_generator_t (gen);

  -- Demonstrate that you can compose homographic functions:
  gen := hfunc_make (1, 0, 0, 2,
                     hfunc_make (1, 1, 0, 1,
                                 hfunc_make (0, 1, 1, 0,
                                             sqrt2_make)));
  run_gen ("(1 + 1/sqrt(2))/2", gen);
  free_generator_t (gen);

end univariate_continued_fraction_task;

----------------------------------------------------------------------
