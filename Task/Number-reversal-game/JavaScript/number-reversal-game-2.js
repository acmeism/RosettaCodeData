function endGame(progress) {
    var scoreId = progress.scoreId,
        result = 'You took ' + progress.count + ' attempts to put the digits in order!';
    if (progress.abort === true) {
        result = 'Game aborted.';
    }
    document.getElementById(scoreId).innerHTML = result;
}

function reverseFirstN(arr, n) {
    var reversed = arr.slice(0, n).reverse();
    return reversed.concat(arr.slice(n));
}

function isSorted(arr) {
    return arr.slice(0).sort().toString() === arr.toString();
}

function gameLoop(progress) {
    if (isSorted(progress.arr)) {
        endGame(progress);
    } else {
        var n = parseInt(window.prompt('How many elements to reverse?', ''), 10);
        if (isNaN(n)) {
            progress.abort = true;
        } else {
            progress.arr = reverseFirstN(progress.arr, n);
            progress.innerHTML += '<p>' + progress.arr + '</p>';
            progress.count += 1;
        }
        if (progress.abort !== true) {
            // allow window to repaint before next guess
            setTimeout(function () {
                gameLoop(progress);
            }, 1);
        }
    }
}

function knuth_shuffle(a) {
    var n = a.length,
        r,
        temp;
    while (n > 1) {
        r = Math.floor(n * Math.random());
        n -= 1;
        temp = a[n];
        a[n] = a[r];
        a[r] = temp;
    }
    return a;
}

function playGame(startId, progressId, scoreId) {
    var progress = document.getElementById(progressId);
    progress.arr = knuth_shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    document.getElementById(startId).innerHTML = '<p>' + progress.arr.toString() + '</p>';

    progress.count = 0;
    progress.scoreId = scoreId;

    // allow window to repaint before prompting for a guess
    setTimeout(function () {
        gameLoop(progress);
    }, 1);
}

playGame('start', 'progress', 'score');
