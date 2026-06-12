require random.fs
here seed !

warnings off

( THE PERCEPTRON )

: randomWeight      2000 random 1000 - s>f 1000e f/ ;
: createPerceptron  create  dup ,  0 ?DO randomWeight f, LOOP ;

variable arity
variable ^weights
variable ^inputs

: perceptron!       dup @ arity !  cell+ ^weights ! ;
: inputs!           ^inputs ! ;

0.0001e fconstant learningConstant
: activate          0e f> IF 1e ELSE -1e THEN ;

: feedForward
    ^weights @  ^inputs @  0e
    arity @  0  ?DO
        dup f@  float + swap
        dup f@  float + swap
        f* f+
    LOOP 2drop activate ;

: train
    feedForward f- learningConstant f*
    ^weights @  ^inputs @
    arity @  0  ?DO
        fdup  dup f@ f*  float + swap
        dup f@ f+  dup f!  float + swap
    LOOP 2drop fdrop ;

( THE TRAINER )

create point   0e f, 0e f, 1e f,   \ x y bias

: x             point ;
: y             point float + ;
: randomX       640 random s>f ;
: randomY       360 random s>f ;

\ y = Ax + B
2e fconstant A
1e fconstant B

: randomizePoint
    randomY fdup y f!
    randomX fdup x f!
    A f* B f+ f<  IF -1e ELSE 1e THEN ;

3 createPerceptron myPerceptron
variable trainings
10000 constant #rounds

: setup         0 ;  \ success counter
: calculate     s>f  #rounds s>f  f/ 100e f* ;
: report        ." After " trainings @ . ." trainings: "
                calculate f. ." % accurate" cr ;
: check         learningConstant f~ IF 1+ THEN ;
: evaluate      randomizePoint feedForward check ;
: evaluate      setup #rounds 0 ?DO evaluate LOOP report ;

: tally         1 trainings +! ;
: timesTrain    0 ?DO randomizePoint train tally LOOP ;

: initialize
    myPerceptron perceptron!
    point inputs!
    0 trainings ! ;
: go
        initialize evaluate
      1 timesTrain evaluate
      1 timesTrain evaluate
      1 timesTrain evaluate
      1 timesTrain evaluate
      1 timesTrain evaluate
      5 timesTrain evaluate
     10 timesTrain evaluate
     30 timesTrain evaluate
     50 timesTrain evaluate
    100 timesTrain evaluate
    300 timesTrain evaluate
    500 timesTrain evaluate ;

go bye
