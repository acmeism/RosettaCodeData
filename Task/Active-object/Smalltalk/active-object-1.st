Object subclass:#Integrator
        instanceVariableNames:'tickRate input s thread'
        classVariableNames:''
        poolDictionaries:''
        category:'Rosetta'

instance methods:

input:aFunctionOfT
    input := aFunctionOfT.

startWithTickRate:r
    "setup and start sampling"
    tickRate := r.
    s := 0.
    thread := [ self integrateLoop ] fork.

stop
    "stop and return the 'final' output"
    thread terminate.
    ^ s

integrateLoop
    "no need for any locks
     - the assignment to s is atomic in Smallalk; its either done or not, when terminated, so who cares"

    |tBegin tPrev tNow kPrev kNow deltaT delta|

    tBegin := tPrev := Timestamp nowWithMilliseconds.
    kPrev := input value:0.

    [true] whileTrue:[
        Delay waitForSeconds: tickRate.
        tNow := Timestamp nowWithMilliseconds.
        kNow := input value:(tNow millisecondDeltaFrom:tBegin) / 1000.

        deltaT := (tNow millisecondDeltaFrom:tPrev) / 1000.
        delta := (kPrev + kNow) * deltaT / 2.

        s := s + delta.
        tPrev := tNow. kPrev := kNow.
    ].

class methods:

example
    #( 0.5 0.1 0.05 0.01 0.005 0.001 0.0005 ) do:[:sampleRate |
        |i|

        i := Integrator new.
        i input:[:t | (2 * Float pi * 0.5 * t) sin].
        i startWithTickRate:sampleRate.

        Delay waitForSeconds:2.
        i input:[:t | 0].
        Delay waitForSeconds:0.5.

        Transcript
            show:'Sample rate: '; showCR:sampleRate;
            showCR:(i stop).
    ].
