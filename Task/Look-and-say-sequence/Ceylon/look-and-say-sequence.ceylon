shared void run() {
	
    function lookAndSay(Integer|String input) {

        variable value digits = if (is Integer input) then input.string else input;
        value builder = StringBuilder();

        while (exists currentChar = digits.first) {
            if (exists index = digits.firstIndexWhere((char) => char != currentChar)) {
                digits = digits[index...];
                builder.append("``index````currentChar``");
            }
            else {
                builder.append("``digits.size````currentChar``");
                break;
            }
        }

        return builder.string;
    }

    variable String|Integer result = 1;
    print(result);
    for (i in 1..14) {
        result = lookAndSay(result);
        print(result);
    }
}
