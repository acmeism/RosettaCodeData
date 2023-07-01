with Ada.Text_IO; use Ada.Text_IO;
procedure hailstone is
	type int_arr is array(Positive range <>) of Integer;
	type int_arr_pt is access all int_arr;

	function hailstones(num:Integer; pt:int_arr_pt) return Integer is
		stones : Integer := 1;
		n : Integer := num;
		begin
		if pt /= null then pt(1) := num; end if;
		while (n/=1) loop
			stones := stones + 1;
			if n mod 2 = 0 then n := n/2;
			else n := (3*n)+1;
			end if;
			if pt /= null then pt(stones) := n; end if;
		end loop;
		return stones;
	end hailstones;
	
	nmax,stonemax,stones : Integer := 0;
	list : int_arr_pt;
begin
	stones := hailstones(27,null);
	list := new int_arr(1..stones);
	stones := hailstones(27,list);
	put(" 27: "&Integer'Image(stones)); new_line;
	for n in 1..4 loop put(Integer'Image(list(n)));	end loop;
	put(" .... ");
	for n in stones-3..stones loop put(Integer'Image(list(n))); end loop;
	new_line;
	for n in 1..100000 loop
		stones := hailstones(n,null);
		if stones>stonemax then
			nmax := n; stonemax := stones;
		end if;
	end loop;
	put_line(Integer'Image(nmax)&" max @ n= "&Integer'Image(stonemax));
end hailstone;
