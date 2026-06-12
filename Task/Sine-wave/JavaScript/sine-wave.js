let ctx = new (window.AudioContext || window.webkitAudioContext)();
let osc = ctx.createOscillator();
osc.frequency.setValueAtTime(440, ctx.currentTime);
osc.connect(ctx.destination);
osc.start();
osc.stop(ctx.currentTime + 5);
