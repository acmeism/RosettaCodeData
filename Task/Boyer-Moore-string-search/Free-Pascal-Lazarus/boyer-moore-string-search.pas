{$mode objfpc}{$H+}
uses strutils, classes;
const s:string = 'GCTAGCTCTACGAGTCTA'+ LineEnding +
		'GGCTATAATGCGTA'+  LineEnding +
		'there would have been a time for such a word'+  LineEnding +
		'needle need noodle needle'+  LineEnding +
		'DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages'+  LineEnding +
		'Nearby farms grew an acre of alfalfa on the dairy''s behalf, with bales of that alfalfa exchanged for milk.';

var
  List:TStringlist;
  matches:SizeIntArray;
  i:SizeInt;
begin
  List := TStringlist.Create;
  try
	  List.Text := s;
	  if FindMatchesBoyerMooreCaseSensitive(List[0],'TCTA',matches,true) then
	  begin
	    write('TCTA found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found');
	
	  if FindMatchesBoyerMooreCaseSensitive(List[1],'TAATAAA',matches,true) then
	  begin
	    write('TAATAAA found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found for TAATAAA');
	
	  if FindMatchesBoyerMooreCaseSensitive(List[2],'word',matches,true) then
	  begin
	    write('word found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found for word');
	
	  if FindMatchesBoyerMooreCaseSensitive(List[3],'needle',matches,true) then
	  begin
	    write('needle found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found for needle');
	
	  if FindMatchesBoyerMooreCaseSensitive(List[4],'and',matches,true) then
	  begin
	    write('and found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found for and');
	
	  if FindMatchesBoyerMooreCaseSensitive(List[5],'alfalfa',matches,true) then
	  begin
	    write('alfalfa found at index: ');
	    for i in matches do write(i:4);
	    writeln;
	  end else writeln('no matches found for alfalfa');
  finally
    List.Free;
  end;
end.
