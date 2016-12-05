shared void run() {
    while(true) {
        variable value low = 1;
        variable value high = 10;
        variable value attempts = 1;
        print("Please choose a number between ``low`` and ``high``.
               Press enter when ready.");
        process.readLine();
        while(true) {
            if(low > high) {
                print("Something is wrong. I give up.");
                break;
            }
            variable value guess = (low + high) / 2;
            print("Is ``guess`` (e)qual, (h)igher or (l)ower to your number?
                   (enter q to quit)");
            value answer = process.readLine()?.trimmed?.lowercased;
            switch(answer)
            case("e") {
                print("I got it in only ``attempts`` ``attempts == 1 then "try" else "tries"``!");
                break;
            }
            case("h") {
                high = guess - 1;
                attempts++;
            }
            case("l") {
                low = guess + 1;
                attempts++;
            }
            case("q") {
                return;
            }
            else {
                print("Please enter an e, h, l or q");
            }
        }
    }
}
