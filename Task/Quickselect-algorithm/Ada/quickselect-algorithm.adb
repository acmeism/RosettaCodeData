----------------------------------------------------------------------

with Ada.Numerics.Float_Random;
with Ada.Text_IO;

procedure quickselect_task
is

  use Ada.Numerics.Float_Random;
  use Ada.Text_IO;

  gen : Generator;

----------------------------------------------------------------------
--
-- procedure partition
--
-- Partitioning a subarray into two halves: one with elements less
-- than or equal to a pivot, the other with elements greater than or
-- equal to a pivot.
--

  generic
    type T is private;
    type T_Array is array (Natural range <>) of T;
  procedure partition
   (less_than : access function
     (x, y : T)
      return Boolean;
    pivot           : in     T;
    i_first, i_last : in     Natural;
    arr             : in out T_Array;
    i_pivot         :    out Natural);

  procedure partition
   (less_than : access function
     (x, y : T)
      return Boolean;
    pivot           : in     T;
    i_first, i_last : in     Natural;
    arr             : in out T_Array;
    i_pivot         :    out Natural)
  is
    i, j : Integer;
    temp : T;
  begin

    i := Integer (i_first) - 1;
    j := i_last + 1;

    while i /= j loop
      -- Move i so everything to the left of i is less than or equal
      -- to the pivot.
      i := i + 1;
      while i /= j and then not less_than (pivot, arr (i)) loop
        i := i + 1;
      end loop;

      -- Move j so everything to the right of j is greater than or
      -- equal to the pivot.
      if i /= j then
        j := j - 1;
        while i /= j and then not less_than (arr (j), pivot) loop
          j := j - 1;
        end loop;
      end if;

      -- Swap entries.
      temp    := arr (i);
      arr (i) := arr (j);
      arr (j) := temp;
    end loop;

    i_pivot := i;

  end partition;

----------------------------------------------------------------------
--
-- procedure quickselect
--
-- Quickselect with a random pivot. Returns the (k+1)st element of a
-- subarray, according to the given order predicate. Also rearranges
-- the subarray so that anything "less than" the (k+1)st element is to
-- the left of it, and anything "greater than" it is to its right.
--
-- I use a random pivot to get O(n) worst case *expected* running
-- time. Code using a random pivot is easy to write and read, and for
-- most purposes comes close enough to a criterion set by Scheme's
-- SRFI-132: "Runs in O(n) time." (See
-- https://srfi.schemers.org/srfi-132/srfi-132.html)
--
-- Of course we are not bound here by SRFI-132, but still I respect
-- it as a guide.
--
-- A "median of medians" pivot gives O(n) running time, but
-- quickselect with such a pivot is a complicated algorithm requiring
-- many comparisons of array elements. A random number generator, by
-- contrast, requires no comparisons of array elements.
--

  generic
    type T is private;
    type T_Array is array (Natural range <>) of T;
  procedure quickselect
   (less_than : access function
     (x, y : T)
      return Boolean;
    i_first, i_last    : in     Natural;
    k                  : in     Natural;
    arr                : in out T_Array;
    the_element        :    out T;
    the_elements_index :    out Natural);

  procedure quickselect
   (less_than : access function
     (x, y : T)
      return Boolean;
    i_first, i_last    : in     Natural;
    k                  : in     Natural;
    arr                : in out T_Array;
    the_element        :    out T;
    the_elements_index :    out Natural)
  is
    procedure T_partition is new partition (T, T_Array);

    procedure qselect
     (less_than : access function
       (x, y : T)
        return Boolean;
      i_first, i_last    : in     Natural;
      k                  : in     Natural;
      arr                : in out T_Array;
      the_element        :    out T;
      the_elements_index :    out Natural)
    is
      i, j    : Natural;
      i_pivot : Natural;
      i_final : Natural;
      pivot   : T;
    begin

      i := i_first;
      j := i_last;

      while i /= j loop
        i_pivot :=
         i + Natural (Float'Floor (Random (gen) * Float (j - i + 1)));
        i_pivot := Natural'Min (j, i_pivot);
        pivot   := arr (i_pivot);

        -- Move the last element to where the pivot had been. Perhaps
        -- the pivot was already the last element, of course. In any
        -- case, we shall partition only from i to j - 1.
        arr (i_pivot) := arr (j);

        -- Partition the array in the range i .. j - 1, leaving out
        -- the last element (which now can be considered garbage).
        T_partition (less_than, pivot, i, j - 1, arr, i_final);

        -- Now everything that is less than the pivot is to the left
        -- of I_final.

        -- Put the pivot at i_final, moving the element that had been
        -- there to the end. If i_final = j, then this element is
        -- actually garbage and will be overwritten with the pivot,
        -- which turns out to be the greatest element. Otherwise, the
        -- moved element is not less than the pivot and so the
        -- partitioning is preserved.
        arr (j)       := arr (i_final);
        arr (i_final) := pivot;

        -- Compare i_final and k, to see what to do next.
        if i_final < k then
          i := i_final + 1;
        elsif k < i_final then
          j := i_final - 1;
        else
          -- Exit the loop.
          i := i_final;
          j := i_final;
        end if;
      end loop;

      the_element        := arr (i);
      the_elements_index := i;

    end qselect;
  begin
    -- Adjust k for the subarray's position.
    qselect
     (less_than, i_first, i_last, k + i_first, arr, the_element,
      the_elements_index);
  end quickselect;

----------------------------------------------------------------------

  type Integer_Array is array (Natural range <>) of Integer;

  procedure integer_quickselect is new quickselect
   (Integer, Integer_Array);

  procedure print_kth
   (less_than : access function
     (x, y : Integer)
      return Boolean;
    k               : in     Positive;
    i_first, i_last : in     Integer;
    arr             : in out Integer_Array)
  is
    copy_of_arr        : Integer_Array (0 .. i_last);
    the_element        : Integer;
    the_elements_index : Natural;
  begin
    for j in 0 .. i_last loop
      copy_of_arr (j) := arr (j);
    end loop;
    integer_quickselect
     (less_than, i_first, i_last, k - 1, copy_of_arr, the_element,
      the_elements_index);
    Put (Integer'Image (the_element));
  end print_kth;

----------------------------------------------------------------------

  example_numbers : Integer_Array := (9, 8, 7, 6, 5, 0, 1, 2, 3, 4);

  function lt
   (x, y : Integer)
    return Boolean
  is
  begin
    return (x < y);
  end lt;

  function gt
   (x, y : Integer)
    return Boolean
  is
  begin
    return (x > y);
  end gt;

begin
  Put ("With < as order predicate: ");
  for k in 1 .. 10 loop
    print_kth (lt'Access, k, 0, 9, example_numbers);
  end loop;
  Put_Line ("");
  Put ("With > as order predicate: ");
  for k in 1 .. 10 loop
    print_kth (gt'Access, k, 0, 9, example_numbers);
  end loop;
  Put_Line ("");
end quickselect_task;

----------------------------------------------------------------------
