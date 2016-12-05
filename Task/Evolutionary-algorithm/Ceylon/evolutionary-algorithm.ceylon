import ceylon.random {
	
	DefaultRandom
}

shared void run() {
	
	value mutationRate = 0.05;
	value childrenPerGeneration = 100;
	value target = "METHINKS IT IS LIKE A WEASEL";
	value alphabet = {' ', *('A'..'Z')};
	value random = DefaultRandom();
	
	value randomLetter => random.nextElement(alphabet);
	
	function fitness(String a, String b) =>
			count {for([c1, c2] in zipPairs(a, b)) c1 == c2};
	
	function mutate(String string) =>
			String {
				for(letter in string)
				if(random.nextFloat() < mutationRate)
				then randomLetter
				else letter
			};
	
	function makeCopies(String string) =>
			{for(i in 1..childrenPerGeneration) mutate(string)};
	
	function chooseFittest(String+ children) =>
			children
			.map((String element) => element->fitness(element, target))
			.max(increasingItem)
			.key;
	
	variable value parent = String {for(i in 1..target.size) randomLetter};
	variable value generationCount = 0;
	function display() => print("``generationCount``: ``parent``");
	
	display();
	while(parent != target) {
		parent = chooseFittest(parent, *makeCopies(parent));
		generationCount++;
		display();
	}
	
	print("mutated into target in ``generationCount`` generations!");
	
}
