// Conjugate a Latin verb. Nigel Galloway: September 30th., 2024
##
procedure myLatin(n:string);
begin
  println($'Tu quae conjugate verba {n}');
  if (n.Length<4) or (n[n.Length-2:]<>'are') then begin println('Te adiuvare non possum'); exit; end;
  |'o','as','at','amus','atis','ant'|.ForEach(g->println($'{n[:n.Length-2]}{g}'));
end;

myLatin('amare');
myLatin('creo');
