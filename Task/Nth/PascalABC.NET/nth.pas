var suffix := |'th', 'st', 'nd', 'rd'| + |'th'| * 6;

function Nth(n: integer)
  := $'{n}''' + if n mod 100 not in 11..19 then suffix[n mod 10] else 'th';

begin
  ((0..24) + (500..524) + (700..724) + (1000..1024))
    .Select(Nth).Println;
end.
