import ceylon.random {
    DefaultRandom
}

shared void run() {
    value random = DefaultRandom();
    value range = 1..10;
    while(true) {
        value chosen = random.nextElement(range);
        print("I have chosen a number between ``range.first`` and ``range.last``.
               What is your guess?");
        while(true) {
            if(exists line = process.readLine()) {
                value guess = Integer.parse(line.trimmed);

                if(is ParseException guess) {
                    print(guess.message);
                    continue;
                }

                switch(guess <=> chosen)
                case (larger) {
                    print("Too high!");
                }
                case (smaller) {
                    print("Too low!");
                }
                case (equal) {
                    print("You got it!");
                    break;
                }
            } else {
                print("Please enter a number!");
            }
        }
    }
}
