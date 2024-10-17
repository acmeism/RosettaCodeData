const
  ANIMALS: array of string = ('Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake', 'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig');
  ELEMENTS: array of string = ('Wood', 'Fire', 'Earth', 'Metal', 'Water');
  ANIMAL_CHARS: array of char  = ('子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥');
  ELEMENT_CHARS: array of array of char = (('甲', '丙', '戊', '庚', '壬'), ('乙', '丁', '己', '辛', '癸'));

function GetYY(year: Integer) := if year Mod 2 = 0 then 'yang' else 'yin';

begin
  var years := |1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017|;
  foreach var year in years do
  begin
    var ei := ((year - 4) Mod 10) div 2;
    var ai := (year - 4) Mod 12;
    var cycle := (year - 4) Mod 60 + 1;
    WriteLn(year, ' is the year of the ', ELEMENTS[ei], ' ', ANIMALS[ai], ' (', GetYY(year), '). ',
    ELEMENT_CHARS[year Mod 2, ei], ANIMAL_CHARS[(year - 4) Mod 12], ' - year ', cycle,' of the cycle');
  end;
end.
