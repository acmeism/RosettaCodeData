import ceylon.random {

	DefaultRandom
}

abstract class Colour(name, ordinal) of red | white | blue  satisfies Comparable<Colour> {
	shared String name;
	shared Integer ordinal;
	string => name;
	compare(Colour other) => this.ordinal <=> other.ordinal;
}

object red extends Colour("red", 0) {}
object white extends Colour("white", 1) {}
object blue extends Colour("blue", 2) {}

Colour[] allColours = `Colour`.caseValues;

shared void run() {
	
	function ordered({Colour*} colours) =>
			colours.paired.every(([c1, c2]) => c1 <= c2);
	
	value random = DefaultRandom();
	
	function randomBalls(Integer length = 15) {
		while (true) {
			value balls = random.elements(allColours).take(length);
			if (!ordered(balls)) {
				return balls.sequence();
			}
		}
	}
	
	function dutchSort({Colour*} balls, Colour mid = white) {
		value array = Array { *balls };
		if (array.empty) {
			return [];
		}
		variable value i = 0;
		variable value j = 0;
		variable value n = array.size - 1;
		while (j <= n) {
			assert (exists ball = array[j]);
			if (ball < mid) {
				array.swap(i, j);
				i ++;
				j ++;
			}
			else if (ball > mid) {
				array.swap(n, j);
				n --;
			}
			else {
				j ++;
			}
		}
		return array;
	}
	
	function idiomaticSort({Colour*} balls) =>
			balls.sort(increasing);
	
    value initialBalls = randomBalls();
	
    "the initial balls are not randomized"
    assert (!ordered(initialBalls));

    print(initialBalls);

    value sortedBalls1 = idiomaticSort(initialBalls);
    value sortedBalls2 = dutchSort(initialBalls);

    "the idiomatic sort didn't work"
    assert (ordered(sortedBalls1));

    "the dutch sort didn't work"
    assert (ordered(sortedBalls2));

    print(sortedBalls1);
    print(sortedBalls2);
}
