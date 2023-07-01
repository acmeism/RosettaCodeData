with ada.text_io;use ada.text_io;

procedure perfect_shuffle is
  function count_shuffle (half_size : Positive) return Positive is
    subtype index is Natural range 0..2 * half_size - 1;
    subtype index_that_move is index range index'first+1..index'last-1;
    type deck is array (index) of index;
    initial, d, next : deck;
    count : Natural := 1;
  begin
    for i in index loop initial (i) := i; end loop;
    d := initial;
    loop
      for i in index_that_move loop
        next (i) := (if d (i) mod 2 = 0 then d(i)/2 else d(i)/2 + half_size);
      end loop;
      exit when next (index_that_move)= initial(index_that_move);
      d := next;
      count := count + 1;
    end loop;
    return count;
  end count_shuffle;
  test : array (Positive range <>) of Positive := (8, 24, 52, 100, 1020, 1024, 10_000);
begin
  for size of test loop
    put_line ("For" & size'img & " cards, there are "& count_shuffle (size / 2)'img & " shuffles needed.");
  end loop;
end perfect_shuffle;
