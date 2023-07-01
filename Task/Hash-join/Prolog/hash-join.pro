% Name/Age	
person_age('Jonah',  27).	
person_age('Alan',   18).	
person_age('Glory',  28).	
person_age('Popeye', 18).	
person_age('Alan',   28).	

% Character/Nemesis
character_nemisis('Jonah', 'Whales').
character_nemisis('Jonah', 'Spiders').
character_nemisis('Alan',  'Ghosts').
character_nemisis('Alan',  'Zombies').
character_nemisis('Glory', 'Buffy').

join_and_print :-
	format('Age\tName\tCharacter\tNemisis\n\n'),		
	forall(
		(person_age(Person, Age), character_nemisis(Person, Nemesis)),	
		format('~w\t~w\t~w\t\t~w\n', [Age, Person, Person, Nemesis])
	).
