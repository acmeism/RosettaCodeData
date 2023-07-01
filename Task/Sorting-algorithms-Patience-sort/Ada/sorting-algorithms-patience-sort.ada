----------------------------------------------------------------------

with Ada.Text_IO;

procedure patience_sort_task is
  use Ada.Text_IO;

  function next_power_of_two
   (n : in Natural)
    return Positive is
    -- This need not be a fast implementation.
    pow2 : Positive;
  begin
    pow2 := 1;
    while pow2 < n loop
      pow2 := pow2 + pow2;
    end loop;
    return pow2;
  end next_power_of_two;

  generic
    type t is private;
    type t_array is array (Integer range <>) of t;
    type sorted_t_indices is array (Integer range <>) of Integer;
  procedure patience_sort
   (less : access function
     (x, y : t)
      return Boolean;
    ifirst : in Integer;
    ilast : in Integer;
    arr : in t_array;
    sorted : out sorted_t_indices);

  procedure patience_sort
   (less : access function
     (x, y : t)
      return Boolean;
    ifirst : in Integer;
    ilast : in Integer;
    arr : in t_array;
    sorted : out sorted_t_indices) is

    num_piles : Integer;
    piles : array (1 .. ilast - ifirst + 1) of Integer :=
     (others => 0);
    links : array (1 .. ilast - ifirst + 1) of Integer :=
     (others => 0);

    function find_pile
     (q : in Positive)
      return Positive is
      --
      -- Bottenbruch search for the leftmost pile whose top is greater
      -- than or equal to some element x. Return an index such that:
      --
      -- * if x is greater than the top element at the far right, then
      --   the index returned will be num-piles.
      --
      -- * otherwise, x is greater than every top element to the left
      --   of index, and less than or equal to the top elements at
      --   index and to the right of index.
      --
      -- References:
      --
      -- * H. Bottenbruch, "Structure and use of ALGOL 60", Journal of
      --   the ACM, Volume 9, Issue 2, April 1962, pp.161-221.
      --   https://doi.org/10.1145/321119.321120
      --
      --   The general algorithm is described on pages 214 and 215.
      --
      -- * https://en.wikipedia.org/w/index.php?title=Binary_search_algorithm&oldid=1062988272#Alternative_procedure
      --
      index : Positive;
      i, j, k : Natural;
    begin
      if num_piles = 0 then
        index := 1;
      else
        j := 0;
        k := num_piles - 1;
        while j /= k loop
          i := (j + k) / 2;
          if less
            (arr (piles (j + 1) + ifirst - 1), arr (q + ifirst - 1))
          then
            j := i + 1;
          else
            k := i;
          end if;
        end loop;
        if j = num_piles - 1 then
          if less
            (arr (piles (j + 1) + ifirst - 1), arr (q + ifirst - 1))
          then
            -- A new pile is needed.
            j := j + 1;
          end if;
        end if;
        index := j + 1;
      end if;
      return index;
    end find_pile;

    procedure deal is
      i : Positive;
    begin
      for q in links'range loop
        i := find_pile (q);
        links (q) := piles (i);
        piles (i) := q;
        num_piles := Integer'max (num_piles, i);
      end loop;
    end deal;

    procedure k_way_merge is
      --
      -- k-way merge by tournament tree.
      --
      -- See Knuth, volume 3, and also
      -- https://en.wikipedia.org/w/index.php?title=K-way_merge_algorithm&oldid=1047851465#Tournament_Tree
      --
      -- However, I store a winners tree instead of the recommended
      -- losers tree. If the tree were stored as linked nodes, it
      -- would probably be more efficient to store a losers
      -- tree. However, I am storing the tree as an array, and one
      -- can find an opponent quickly by simply toggling the least
      -- significant bit of a competitor's array index.
      --
      total_external_nodes : Positive;
      total_nodes : Positive;
    begin

      total_external_nodes := next_power_of_two (num_piles);
      total_nodes := (2 * total_external_nodes) - 1;

      declare

        -- In Fortran I had the length-2 dimension come first, to
        -- take some small advantage of column-major order. The
        -- recommendation for Ada compilers, however, is to use
        -- row-major order. So I have reversed the order.
        winners : array (1 .. total_nodes, 1 .. 2) of Integer :=
         (others => (0, 0));

        function find_opponent
         (i : Natural)
          return Natural is
        begin
          return (if i rem 2 = 0 then i + 1 else i - 1);
        end find_opponent;

        function play_game
         (i : Positive)
          return Positive is
          j, iwinner : Positive;
        begin
          j := find_opponent (i);
          if winners (i, 1) = 0 then
            iwinner := j;
          elsif winners (j, 1) = 0 then
            iwinner := i;
          elsif less
            (arr (winners (j, 1) + ifirst - 1),
             arr (winners (i, 1) + ifirst - 1))
          then
            iwinner := j;
          else
            iwinner := i;
          end if;
          return iwinner;
        end play_game;

        procedure replay_games
         (i : Positive) is
          j, iwinner : Positive;
        begin
          j := i;
          while j /= 1 loop
            iwinner := play_game (j);
            j := j / 2;
            winners (j, 1) := winners (iwinner, 1);
            winners (j, 2) := winners (iwinner, 2);
          end loop;
        end replay_games;

        procedure build_tree is
          istart, i, iwinner : Positive;
        begin
          for i in 1 .. total_external_nodes loop
            -- Record which pile a winner will have come from.
            winners (total_external_nodes - 1 + i, 2) := i;
          end loop;

          for i in 1 .. num_piles loop
            -- The top of each pile becomes a starting competitor.
            winners (total_external_nodes + i - 1, 1) := piles (i);
          end loop;

          for i in 1 .. num_piles loop
            -- Discard the top of each pile
            piles (i) := links (piles (i));
          end loop;

          istart := total_external_nodes;
          while istart /= 1 loop
            i := istart;
            while i <= (2 * istart) - 1 loop
              iwinner := play_game (i);
              winners (i / 2, 1) := winners (iwinner, 1);
              winners (i / 2, 2) := winners (iwinner, 2);
              i := i + 2;
            end loop;
            istart := istart / 2;
          end loop;
        end build_tree;

        isorted, i, next : Integer;

      begin
        build_tree;
        isorted := 0;
        while winners (1, 1) /= 0 loop
          sorted (sorted'first + isorted) :=
           winners (1, 1) + ifirst - 1;
          isorted := isorted + 1;
          i := winners (1, 2);
          next := piles (i);     -- The next top of pile i.
          if next /= 0 then
            piles (i) := links (next); -- Drop that top.
          end if;
          i := (total_nodes / 2) + i;
          winners (i, 1) := next;
          replay_games (i);
        end loop;
      end;

    end k_way_merge;

  begin
    deal;
    k_way_merge;
  end patience_sort;

begin

  -- A demonstration.

  declare

    type integer_array is array (Integer range <>) of Integer;
    procedure integer_patience_sort is new patience_sort
     (Integer, integer_array, integer_array);

    subtype int25_array is integer_array (1 .. 25);

    example_numbers : constant int25_array :=
     (22, 15, 98, 82, 22, 4, 58, 70, 80, 38, 49, 48, 46, 54, 93, 8,
      54, 2, 72, 84, 86, 76, 53, 37, 90);

    sorted_numbers : int25_array := (others => 0);

    function less
     (x, y : Integer)
      return Boolean is
    begin
      return (x < y);
    end less;

  begin
    integer_patience_sort
     (less'access, example_numbers'first, example_numbers'last,
      example_numbers, sorted_numbers);

    Put ("unsorted  ");
    for i of example_numbers loop
      Put (Integer'image (i));
    end loop;
    Put_Line ("");
    Put ("sorted    ");
    for i of sorted_numbers loop
      Put (Integer'image (example_numbers (i)));
    end loop;
    Put_Line ("");
  end;

end patience_sort_task;

----------------------------------------------------------------------
