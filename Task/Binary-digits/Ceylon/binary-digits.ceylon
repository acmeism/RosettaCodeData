    shared void run() {

        void printBinary(Integer integer) =>
            print(Integer.format(integer, 2));

        printBinary(5);
        printBinary(50);
        printBinary(9k);
    }
