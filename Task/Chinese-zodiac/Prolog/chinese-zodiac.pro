:- initialization(main).

animals(['Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake', 'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig']).

elements(['Wood', 'Fire', 'Earth', 'Metal', 'Water']).

animal_chars(['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']).

element_chars([['甲', '丙', '戊', '庚', '壬'], ['乙', '丁', '己', '辛', '癸']]).

years([1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017]).

year_animal(Year, Animal) :-
    I is ((Year - 4) mod 12) + 1,
    animals(Animals),
    nth(I, Animals, Animal).

year_element(Year, Element) :-
    I is ((Year - 4) mod 10) div 2 + 1,
    elements(Elements),
    nth(I, Elements, Element).

year_animal_char(Year, AnimalChar) :-
    I is (Year - 4) mod 12 + 1,
    animal_chars(AnimalChars),
    nth(I, AnimalChars, AnimalChar).

year_element_char(Year, ElementChar) :-
    I1 is Year mod 2 + 1,
    element_chars(ElementChars),
    nth(I1, ElementChars, ElementChars1),
    I2 is (Year - 4) mod 10 div 2 + 1,
    nth(I2, ElementChars1, ElementChar).

year_yin_yang(Year, YinYang) :-
    Year mod 2 =:= 0 -> YinYang = 'yang' ; YinYang = 'yin'.

main :-
    years(Years),
    forall(member(Year, Years), (
        write(Year),
        write(' is the year of the '),
        year_element(Year, Element),
        write(Element),
        write(' '),
        year_animal(Year, Animal),
        write(Animal),
        write(' '),
        year_yin_yang(Year, YinYang),
        write('('),
        write(YinYang),
        write('). '),
        year_element_char(Year, ElementChar),
        write(ElementChar),
        year_animal_char(Year, AnimalChar),
        write(AnimalChar),
        nl
    )).
