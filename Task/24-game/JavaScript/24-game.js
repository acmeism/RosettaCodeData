function twentyfour(numbers, input) {
    var invalidChars = /[^\d\+\*\/\s-\(\)]/;

    var validNums = function(str) {
        // Create a duplicate of our input numbers, so that
        // both lists will be sorted.
        var mnums = numbers.slice();
        mnums.sort();

        // Sort after mapping to numbers, to make comparisons valid.
        return str.replace(/[^\d\s]/g, " ")
            .trim()
            .split(/\s+/)
            .map(function(n) { return parseInt(n, 10); })
            .sort()
            .every(function(v, i) { return v === mnums[i]; });
    };

    var validEval = function(input) {
        try {
            return eval(input);
        } catch (e) {
            return {error: e.toString()};
        }
    };

    if (input.trim() === "") return "You must enter a value.";
    if (input.match(invalidChars)) return "Invalid chars used, try again. Use only:\n + - * / ( )";
    if (!validNums(input)) return "Wrong numbers used, try again.";
    var calc = validEval(input);
    if (typeof calc !== 'number') return "That is not a valid input; please try again.";
    if (calc !== 24) return "Wrong answer: " + String(calc) + "; please try again.";
    return input + " == 24.  Congratulations!";
};

// I/O below.

while (true) {
    var numbers = [1, 2, 3, 4].map(function() {
        return Math.floor(Math.random() * 8 + 1);
    });

    var input = prompt(
        "Your numbers are:\n" + numbers.join(" ") +
        "\nEnter expression. (use only + - * / and parens).\n", +"'x' to exit.", "");

    if (input === 'x') {
        break;
    }
    alert(twentyfour(numbers, input));
}
