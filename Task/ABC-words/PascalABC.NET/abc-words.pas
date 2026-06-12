// ABC words. Nigel Galloway: August 29th., 2024
##
var izABC:string->boolean:=n->System.Text.RegularExpressions.Regex.Match(n,'^[^bc]*a[^c]*b.*c').Value.Length>0;
foreach s:string in System.IO.File.ReadLines('unixdict.txt') do if izABC(s) then println(s);
