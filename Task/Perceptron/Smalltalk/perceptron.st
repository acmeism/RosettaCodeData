Number extend [

    activate
        [^self > 0 ifTrue: [1] ifFalse: [-1]]
]

Object subclass: Perceptron [

    | weights |

    feedForward: inputArray
        [^(self sumOfWeighted: inputArray) activate]

    train: inputArray desire: expected
        [| actual error |
        actual := self feedForward: inputArray.
        error := 0.0001 * (expected - actual).
        weights := weights
            with: inputArray
            collect: [:weight :input | weight + (error * input)]]

    sumOfWeighted: inputArray
        [^(self weighted: inputArray)
            inject: 0
            into: [:each :sum | each + sum]]

    weighted: inputArray
        [^weights
            with: inputArray
            collect: [:weight :input | weight * input]]

    Perceptron class >> new: arity
        [^self basicNew
            initialize: arity;
            yourself]

    initialize: arity
        [weights := 1
            to: arity
            collect: [:x | self randomWeight]]

    randomWeight
        [^(Random between: -1000 and: 1000) / 1000]
]

Perceptron class extend [

    | perceptron trainings input expected actual |

    evaluationSamples := 100000.

    initializeTest
        [perceptron := self new: 3.
        input := Array new: 3.
        trainings := 0.
        input at: 1 put: 1. "Bias"]

    randomizeSample
        [| x y |
        x := Random between: 0 and: 640-1.
        y := Random between: 0 and: 360-1.
        expected := (y >= (2*x+1)) ifTrue: [1] ifFalse: [-1].
        input at: 2 put: x.
        input at: 3 put: y]

    test
        [self
            initializeTest; evaluate;
            train: 1; evaluate;
            train: 1; evaluate;
            train: 1; evaluate;
            train: 1; evaluate;
            train: 1; evaluate;
            train: 5; evaluate;
            train: 10; evaluate;
            train: 30; evaluate;
            train: 50; evaluate;
            train: 100; evaluate;
            train: 300; evaluate;
            train: 500; evaluate]

    evaluate
        [| hits |
        hits := 0.
        evaluationSamples timesRepeat:
            [self randomizeSample.
            expected = (perceptron feedForward: input)
                ifTrue: [hits := hits + 1]].
        Transcript
            display: 'After ';
            display: trainings;
            display: ' trainings: ';
            display: (hits / evaluationSamples * 100) asFloat;
            display: ' % accuracy';
            nl]

    train: anInteger
        [anInteger timesRepeat:
            [self randomizeSample.
            perceptron
                train: input
                desire: expected.
            trainings := trainings + 1]]
]

Perceptron test.
