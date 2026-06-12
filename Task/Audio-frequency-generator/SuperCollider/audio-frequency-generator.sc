// the server application detects audio hardware.
Server.default.boot;

// play a sine monotone at 440 Hz and amplitude 0.2
{ SinOsc.ar(440) * 0.2 }.play;

// use the cursor position to adjust frequency and amplitude (ranges are exponential)
{ SinOsc.ar(MouseX.kr(40, 20000, 1)) * MouseY.kr(0.001, 0.5, 1) }.play;

// use the cursor position to switch between sine wave, square wave and triangular sawtooth
// the rounding and lag smoothes the transition between them
{ SelectX.ar(MouseX.kr(0, 2).round.lag, [ SinOsc.ar, Pulse.ar, LFTri.ar ]) * 0.1 }.play;

// the same expressed as an array of functions of a common phase
(
{
    var phase = LFSaw.ar;
    var functions = [
        { |x| sin(x * pi) },
        { |x| x > 0 },
        { |x| abs(x) },
    ];
    var which = MouseX.kr(0, 2);
    functions.sum { |f, i|
        abs(which - i) < 0.5 * f.(phase)
    } * 0.1
}.play
)

// sound stops on exit
Server.default.quit;
