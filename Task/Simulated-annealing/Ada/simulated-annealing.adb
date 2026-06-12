----------------------------------------------------------------------
--
-- The Rosetta Code simulated annealing task in Ada.
--
-- This implementation demonstrates that Ada has fixed-point numbers
-- support built in. Otherwise there is no particular reason I used
-- fixed-point instead of floating-point numbers.
--
-- (Actually, for the square root and exponential, I cheat and use the
-- floating-point functions.)
--
----------------------------------------------------------------------

with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;

procedure simanneal
is

  Bigint : constant := 1_000_000_000;
  Bigfpt : constant := 1_000_000_000.0;

  -- Fixed point numbers.
  type Fixed_Point is delta 0.000_01 range 0.0 .. Bigfpt;

  -- Integers.
  subtype Zero_or_One is Integer range 0 .. 1;
  subtype Coordinate is Integer range 0 .. 9;
  subtype City_Location is Integer range 0 .. 99;
  subtype Nonzero_City_Location is City_Location range 1 .. 99;
  subtype Path_Index is City_Location;
  subtype Nonzero_Path_Index is Nonzero_City_Location;

  -- Arrays.
  type Path_Vector is array (Path_Index) of City_Location;
  type Neighborhood_Array is array (1 .. 8) of City_Location;

  -- Random numbers.
  subtype Random_Number is Integer range 0 .. Bigint - 1;
  package Random_Numbers is new Ada.Numerics.Discrete_Random
   (Random_Number);
  use Random_Numbers;

  gen : Generator;

  function Randnum
    return Fixed_Point
  is
  begin
    return (Fixed_Point (Random (gen)) / Fixed_Point (Bigfpt));
  end Randnum;

  function Random_Natural
   (imin : Natural;
    imax : Natural)
    return Natural
  is
  begin
    -- There may be a tiny bias in the result, due to imax-imin+1 not
    -- being a divisor of Bigint. The algorithm should work, anyway.
    return imin + (Random (gen) rem (imax - imin + 1));
  end Random_Natural;

  function Random_City_Location
   (minloc : City_Location;
    maxloc : City_Location)
    return City_Location
  is
  begin
    return City_Location (Random_Natural (minloc, maxloc));
  end Random_City_Location;

  function Random_Path_Index
   (imin : Path_Index;
    imax : Path_Index)
    return Path_Index
  is
  begin
    return Random_City_Location (imin, imax);
  end Random_Path_Index;

  package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);
  package City_Location_IO is new Ada.Text_IO.Integer_IO
   (City_Location);
  package Fixed_Point_IO is new Ada.Text_IO.Fixed_IO (Fixed_Point);

  function sqrt
   (x : Fixed_Point)
    return Fixed_Point
  is
  begin
    -- Cheat by using the floating-point routine. It is an exercise
    -- for the reader to write a true fixed-point function.
    return
     Fixed_Point (Ada.Numerics.Elementary_Functions.Sqrt (Float (x)));
  end sqrt;

  function expneg
   (x : Fixed_Point)
    return Fixed_Point
  is
  begin
    -- Cheat by using the floating-point routine. It is an exercise
    -- for the reader to write a true fixed-point function.
    return
     Fixed_Point (Ada.Numerics.Elementary_Functions.Exp (-Float (x)));
  end expneg;

  function i_Coord
   (loc : City_Location)
    return Coordinate
  is
  begin
    return loc / 10;
  end i_Coord;

  function j_Coord
   (loc : City_Location)
    return Coordinate
  is
  begin
    return loc rem 10;
  end j_Coord;

  function Location
   (i : Coordinate;
    j : Coordinate)
    return City_Location
  is
  begin
    return (10 * i) + j;
  end Location;

  function distance
   (loc1 : City_Location;
    loc2 : City_Location)
    return Fixed_Point
  is
    i1, j1 : Coordinate;
    i2, j2 : Coordinate;
    di, dj : Coordinate;
  begin
    i1 := i_Coord (loc1);
    j1 := j_Coord (loc1);
    i2 := i_Coord (loc2);
    j2 := j_Coord (loc2);
    di := (if i1 < i2 then i2 - i1 else i1 - i2);
    dj := (if j1 < j2 then j2 - j1 else j1 - j2);
    return sqrt (Fixed_Point ((di * di) + (dj * dj)));
  end distance;

  procedure Randomize_Path_Vector
   (path : out Path_Vector)
  is
    j      : Nonzero_Path_Index;
    xi, xj : Nonzero_City_Location;
  begin
    for i in 0 .. 99 loop
      path (i) := i;
    end loop;

    -- Do a Fisher-Yates shuffle of elements 1 .. 99.
    for i in 1 .. 98 loop
      j        := Random_Path_Index (i + 1, 99);
      xi       := path (i);
      xj       := path (j);
      path (i) := xj;
      path (j) := xi;
    end loop;
  end Randomize_Path_Vector;

  function Path_Length
   (path : Path_Vector)
    return Fixed_Point
  is
    len : Fixed_Point;
  begin
    len := distance (path (0), path (99));
    for i in 0 .. 98 loop
      len := len + distance (path (i), path (i + 1));
    end loop;
    return len;
  end Path_Length;

  -- Switch the index of s to switch which s is current and which is
  -- the trial vector.
  s : array (0 .. 1) of Path_Vector;

  Current : Zero_or_One;

  function Trial
    return Zero_or_One
  is
  begin
    return 1 - Current;
  end Trial;

  procedure Accept_Trial
  is
  begin
    Current := 1 - Current;
  end Accept_Trial;

  procedure Find_Neighbors
   (loc           :     City_Location;
    neighbors     : out Neighborhood_Array;
    num_neighbors : out Integer)
  is
    i, j                           : Coordinate;
    c1, c2, c3, c4, c5, c6, c7, c8 : City_Location := 0;

    procedure Add_Neighbor
     (neighbor : City_Location)
    is
    begin
      if neighbor /= 0 then
        num_neighbors             := num_neighbors + 1;
        neighbors (num_neighbors) := neighbor;
      end if;
    end Add_Neighbor;

  begin
    i := i_Coord (loc);
    j := j_Coord (loc);

    if i < 9 then
      c1 := Location (i + 1, j);
      if j < 9 then
        c2 := Location (i + 1, j + 1);
      end if;
      if 0 < j then
        c3 := Location (i + 1, j - 1);
      end if;
    end if;
    if 0 < i then
      c4 := Location (i - 1, j);
      if j < 9 then
        c5 := Location (i - 1, j + 1);
      end if;
      if 0 < j then
        c6 := Location (i - 1, j - 1);
      end if;
    end if;
    if j < 9 then
      c7 := Location (i, j + 1);
    end if;
    if 0 < j then
      c8 := Location (i, j - 1);
    end if;

    num_neighbors := 0;
    Add_Neighbor (c1);
    Add_Neighbor (c2);
    Add_Neighbor (c3);
    Add_Neighbor (c4);
    Add_Neighbor (c5);
    Add_Neighbor (c6);
    Add_Neighbor (c7);
    Add_Neighbor (c8);
  end Find_Neighbors;

  procedure Make_Neighbor_Path
  is
    u, v          : City_Location;
    neighbors     : Neighborhood_Array;
    num_neighbors : Integer;
    j, iu, iv     : Path_Index;
  begin
    for i in 0 .. 99 loop
      s (Trial) := s (Current);
    end loop;

    u := Random_City_Location (1, 99);
    Find_Neighbors (u, neighbors, num_neighbors);
    v := neighbors (Random_Natural (1, num_neighbors));

    j  := 0;
    iu := 0;
    iv := 0;
    while iu = 0 or iv = 0 loop
      if s (Trial) (j + 1) = u then
        iu := j + 1;
      elsif s (Trial) (j + 1) = v then
        iv := j + 1;
      end if;
      j := j + 1;
    end loop;
    s (Trial) (iu) := v;
    s (Trial) (iv) := u;
  end Make_Neighbor_Path;

  function Temperature
   (kT   : Fixed_Point;
    kmax : Natural;
    k    : Natural)
    return Fixed_Point
  is
  begin
    return
     kT * (Fixed_Point (1) - (Fixed_Point (k) / Fixed_Point (kmax)));
  end Temperature;

  function Probability
   (delta_E : Fixed_Point;
    T       : Fixed_Point)
    return Fixed_Point
  is
    prob : Fixed_Point;
  begin
    if T = Fixed_Point (0.0) then
      prob := Fixed_Point (0.0);
    else
      prob := expneg (delta_E / T);
    end if;
    return prob;
  end Probability;

  procedure Show
   (k : Natural;
    T : Fixed_Point;
    E : Fixed_Point)
  is
  begin
    Put (" ");
    Natural_IO.Put (k, Width => 7);
    Put (" ");
    Fixed_Point_IO.Put (T, Fore => 5, Aft => 1);
    Put (" ");
    Fixed_Point_IO.Put (E, Fore => 7, Aft => 2);
    Put_Line ("");
  end Show;

  procedure Display_Path
   (path : Path_Vector)
  is
  begin
    for i in 0 .. 99 loop
      City_Location_IO.Put (path (i), Width => 2);
      Put (" ->");
      if i rem 8 = 7 then
        Put_Line ("");
      else
        Put (" ");
      end if;
    end loop;
    City_Location_IO.Put (path (0), Width => 2);
  end Display_Path;

  procedure Simulate_Annealing
   (kT   : Fixed_Point;
    kmax : Natural)
  is
    kshow   : Natural := kmax / 10;
    E       : Fixed_Point;
    E_trial : Fixed_Point;
    T       : Fixed_Point;
    P       : Fixed_Point;
  begin
    E := Path_Length (s (Current));
    for k in 0 .. kmax loop
      T := Temperature (kT, kmax, k);
      if k rem kshow = 0 then
        Show (k, T, E);
      end if;
      Make_Neighbor_Path;
      E_trial := Path_Length (s (Trial));
      if E_trial <= E then
        Accept_Trial;
        E := E_trial;
      else
        P := Probability (E_trial - E, T);
        if P = Fixed_Point (1) or else Randnum <= P then
          Accept_Trial;
          E := E_trial;
        end if;
      end if;
    end loop;
  end Simulate_Annealing;

  kT   : constant := Fixed_Point (1.0);
  kmax : constant := 1_000_000;

begin

  Reset (gen);

  Current := 0;
  Randomize_Path_Vector (s (Current));

  Put_Line ("");
  Put ("   kT:");
  Put_Line (Fixed_Point'Image (kT));
  Put ("   kmax:");
  Put_Line (Natural'Image (kmax));
  Put_Line ("");
  Put_Line ("       k       T       E(s)");
  Simulate_Annealing (kT, kmax);
  Put_Line ("");
  Put_Line ("Final path:");
  Display_Path (s (Current));
  Put_Line ("");
  Put_Line ("");
  Put ("Final E(s): ");
  Fixed_Point_IO.Put (Path_Length (s (Current)), Fore => 3, Aft => 2);
  Put_Line ("");
  Put_Line ("");

end simanneal;

----------------------------------------------------------------------
