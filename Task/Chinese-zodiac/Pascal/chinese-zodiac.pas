type
	animalCycle = (rat, ox, tiger, rabbit, dragon, snake,
		horse, goat, monkey, rooster, dog, pig);
	elementCycle = (wood, fire, earth, metal, water);
	aspectCycle = (yang, yin);
		
	zodiac = record
			animal: animalCycle;
			element: elementCycle;
			aspect: aspectCycle;
		end;

function getZodiac(year: integer): zodiac;
begin
	year := pred(year, 4);
	getZodiac := zodiac[
			animal: succ(rat, year mod 12);
			element: succ(wood, year mod 10 div 2);
			aspect: succ(yang, year mod 2);
		]
end;
