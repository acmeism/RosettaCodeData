Rebol [
    title: "Rosetta code: Audio frequency generator"
    file:  %Audio_frequency_generator.r3
    url:   https://rosettacode.org/wiki/Audio_frequency_generator
]

;; Import the MiniAudio extension for audio playback functionality
;; See: https://github.com/Oldes/Rebol-MiniAudio
audio: import miniaudio

;; Initialize the first available playback device.
;; IMPORTANT: The device handle must be kept in a variable — if it goes out of
;; scope, the garbage collector will release it and playback will stop.
device: audio/init-playback 1

;; Phase accumulators used to drive the frequency modulation over time.
;; Starting at 0 and PI gives the two oscillators an initial phase offset,
;; so the modulation pattern doesn't begin symmetrically.
a: 0 b: PI
with audio [
    ;; Create a sine waveform node with amplitude 0.5 (half volume) at 440 Hz (concert A).
    ;; `probe` prints the node details to the console for debugging.
    probe wave: make-waveform-node type_sine 0.5 440.0
    print ["amplitude:" wave/amplitude "frequency:" wave/frequency]

    ;; Begin playback with a 3-second fade-in.
    ;; `probe` prints the resulting sound handle for debugging.
    probe sound: play/fade wave 0:0:3

    ;; First modulation loop: slower, wider sweeps.
    ;; Increments `a` and `b` at different rates so their product creates
    ;; a slowly evolving, non-repeating Lissajous-style frequency pattern.
    ;; The base frequency 440 Hz is modulated ±220 Hz by sin(a)*cos(b).
    loop 500 [
        a: a + 0.01                                         ;; advance slower phase
        b: b + 0.006                                        ;; advance faster phase
        wave/frequency: 440.0 + (220.0 * ((sin a) * cos b)) ;; apply FM to live waveform
        wait 0.01                                           ;; ~100 updates/sec
    ]

    ;; Begin a 2-second fade-out while the second modulation loop runs below
    stop/fade sound 0:0:2

    ;; Second modulation loop: faster increments and shorter wait produce a
    ;; more agitated, higher-speed sweep as the sound fades out.
    loop 400 [
        a: a + 0.02                                         ;; faster phase advance
        b: b + 0.003                                        ;; slower phase advance (reversed ratio)
        wave/frequency: 440.0 + (220.0 * ((sin a) * cos b)) ;; continue FM modulation
        wait 0.005                                          ;; ~200 updates/sec
    ]
]
