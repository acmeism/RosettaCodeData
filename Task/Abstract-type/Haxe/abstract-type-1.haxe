interface Vocal {
	public function speak():String;
}

interface Gravitational {
	public function getWeight():Int;
}

abstract class Dog implements Vocal implements Gravitational {
	public function speak():String {
		return "Woof";
	}

	public function new() {}
}

class Chihuahua extends Dog {
	public function getWeight():Int {
		return 5;
	}
}

class GreatDane extends Dog {
	public function getWeight():Int {
		return 150;
	}
}

class Main {
	static public function main():Void {
		var dogs:Array<Dog> = [];

		var david = new Chihuahua();
		var goliath = new GreatDane();

		dogs.push(david);
		dogs.push(goliath);

		for (dog in dogs) {
			trace(dog.speak());
			trace(dog.getWeight());
		}
	}
}
