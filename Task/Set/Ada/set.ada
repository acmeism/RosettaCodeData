with ada.containers.ordered_sets, ada.text_io;
use ada.text_io;

procedure set_demo is
	package cs is new ada.containers.ordered_sets (character); use cs;

	function "+" (s : string) return set is
	(if s = "" then empty_set else Union(+ s(s'first..s'last - 1), To_Set (s(s'last))));

	function "-" (s : Set) return string is
	(if s = empty_set then "" else - (s - To_Set (s.last_element)) & s.last_element);
	s1, s2 : set;
begin
	loop
		put ("s1= ");
		s1 := + get_line;		
		exit when s1 = +"Quit!";
		put ("s2= ");
		s2 := + get_line;
		Put_Line("Sets [" & (-s1) & "], [" & (-s2) & "] of size"
                & S1.Length'img & " and" & s2.Length'img & ".");
  		Put_Line("Intersection:   [" & (-(Intersection(S1, S2))) & "],");
  		Put_Line("Union:          [" & (-(Union(s1, s2)))        & "],");
  		Put_Line("Difference:     [" & (-(Difference(s1, s2)))   & "],");
  		Put_Line("Symmetric Diff: [" & (-(s1 xor s2)) & "],");
  		Put_Line("Subset: "  & Boolean'Image(s1.Is_Subset(s2))
              & ", Equal: " & Boolean'Image(s1 = s2) & ".");
	end loop;
end set_demo;
