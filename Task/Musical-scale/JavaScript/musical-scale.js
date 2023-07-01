<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Sample Page</title>
<script>
function musicalScale(freqArr){
    // create web audio api context
    var AudioContext = window.AudioContext || window.webkitAudioContext;
    var audioCtx = new AudioContext();

    // create oscillator and gain node
    var oscillator = audioCtx.createOscillator();
    var gainNode = audioCtx.createGain();

    // connect oscillator to gain node to speakers
    oscillator.connect(gainNode);
    gainNode.connect(audioCtx.destination);

    // set frequencies to play
    duration = 0.5   // seconds
    freqArr.forEach(function (freq, i){
        oscillator.frequency.setValueAtTime(freq, audioCtx.currentTime + i * duration);
    });

    // start playing!
    oscillator.start();
    // stop playing!
    oscillator.stop(audioCtx.currentTime + freqArr.length * duration);
}
</script>
</head>
<body>
<button onclick="musicalScale([261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25]);">Play scale</button>
</body>
</html>
