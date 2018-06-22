shared void run() {

    print("please enter two numbers for me to add");
    value input = process.readLine();
    if (exists input) {
        value tokens = input.split().map(Integer.parse);
        if (tokens.any((element) => element is ParseException)) {
            print("numbers only, please");
            return;
        }
        value numbers = tokens.narrow<Integer>();
        if (numbers.size != 2) {
            print("two numbers, please");
        }
        else if (!numbers.every((Integer element) => -1k <= element <= 1k)) {
            print("only numbers between -1000 and 1000, please");
        }
        else if (exists a = numbers.first, exists b = numbers.last) {
            print(a + b);
        }
        else {
            print("something went wrong");
        }
    }
}
