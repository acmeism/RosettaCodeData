/*
H 	Prints "Hello, world!"
Q 	Prints the entire text of the source code file.
9 	Prints the complete canonical lyrics to "99 Bottles of Beer on the Wall"
+ 	Increments the accumulator.
 */
$accumulator = 0;
echo 'HQ9+: ';
$program = trim(fgets(STDIN));

foreach (str_split($program) as $chr) {
    switch ($chr) {
        case 'H':
        case 'h':
            printHelloWorld();
            break;
        case 'Q':
        case 'q':
            printSource($program);
            break;
        case '9':
            print99Bottles();
            break;
        case '+':
            $accumulator = incrementAccumulator($accumulator);
            break;
        default:
            printError($chr);
    }
}

function printHelloWorld() {
    echo 'Hello, world!'. PHP_EOL;
}

function printSource($program) {
    echo var_export($program, true) . PHP_EOL;
}

function print99Bottles() {
    $n = 99;
    while($n >= 1) {
        echo $n;
        echo ' Bottles of Beer on the Wall ';
        echo $n;
        echo ' bottles of beer, take one down pass it around ';
        echo $n-1;
        echo ' bottles of beer on the wall.'. PHP_EOL;
        $n--;
    }
}

function incrementAccumulator($accumulator) {
    return ++$accumulator;
}

function printError($chr) {
    echo "Invalid input: ". $chr;
}
