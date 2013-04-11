var number = Math.ceil(Math.random() * 100);

function verify() {
    var guess = Number(this.elements.guess.value),
        output = document.getElementById('output');

    if (isNaN(guess)) {
        output.innerHTML = 'Enter a number.';
    } else if (number === guess) {
        output.innerHTML = 'You guessed right!';
    } else if (guess > 100) {
        output.innerHTML = 'Your guess is out of the 1 to 100 range.';
    } else if (guess > number) {
        output.innerHTML = 'Your guess is too high.';
    } else if (guess < number) {
        output.innerHTML = 'Your guess is too low.';
    }
    return false;
}

document.getElementById('guessNumber').onsubmit = verify;
