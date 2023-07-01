import ceylon.random {

	DefaultRandom
}

shared void run() {
    value random = DefaultRandom();
    value element = random.nextElement([1, 2, 3, 4, 5, 6]);
    print(element);
}
