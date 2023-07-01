#!/usr/bin/env js

function main() {
    guessTheNumber(1, 100);
}

function guessTheNumber(low, high) {
    var num = randOnRange(low, high);
    var guessCount = 0;

    function checkGuess(n) {
        if (n < low || n > high) {
            print('That number is not between ' + low + ' and ' + high + '!');
            return false;
        }

        if (n == num) {
            print('You got it in ' + String(guessCount) + ' tries.');
            return true;
        }

        if (n < num) {
            print('Too low.');
        } else {
            print('Too high.');
        }
        return false;
    }

    print('I have picked a number between ' + low + ' and ' + high + '. Try to guess it!');
    while (true) {
        guessCount++;
        putstr("  Your guess: ");
        var n = parseInt(readline());
        if (checkGuess(n)) break;
    }
}

function randOnRange(low, high) {
    var r = Math.random();
    return Math.floor(r * (high - low + 1)) + low;
}

main();
