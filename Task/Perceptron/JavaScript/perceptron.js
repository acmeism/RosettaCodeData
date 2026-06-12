const EPOCH = 1500, TRAINING = 1, TRANSITION = 2, SHOW = 3;

var perceptron;
var counter = 0;
var learnRate = 0.02;
var state = TRAINING;

function setup() {
    createCanvas( 800, 600 );
    clearBack();
    perceptron = new Perceptron( 2 );
}

function draw() {
    switch( state ) {
        case TRAINING: training(); break;
        case TRANSITION: transition(); break;
        case SHOW: show(); break;
    }
}

function clearBack() {
    background( 0 );
    stroke( 255 );
    strokeWeight( 4 );

    var x = width;
    line( 0, 0, x, lineDef( x ) );
}

function transition() {
    clearBack();
    state = SHOW;
}

function lineDef( x ) {
    return .75 * x;
}

function training() {
    var a = random( width ),
        b = random( height );

    lDef = lineDef( a ) > b ? -1 : 1;

    perceptron.setInput( [a, b] );
    perceptron.feedForward();
    var pRes = perceptron.getOutput();
    var match = (pRes == lDef);
    var clr;

    if( !match ) {
        var err = ( pRes - lDef ) * learnRate;
        perceptron.adjustWeights( err );

        clr = color( 255, 0, 0 );

    } else {
        clr = color( 0, 255, 0 );
    }

    noStroke();
    fill( clr );
    ellipse( a, b, 4, 4 );

    if( ++counter == EPOCH ) state = TRANSITION;
}

function show() {
    var a = random( width ),
        b = random( height ),
        clr;

    perceptron.setInput( [a, b] );
    perceptron.feedForward();
    var pRes = perceptron.getOutput();

    if( pRes < 0 )
        clr = color( 255, 0, 0 );
    else
        clr = color( 0, 255, 0 );

    noStroke();
    fill( clr );
    ellipse( a, b, 4, 4 );
}

function Perceptron( inNumber ) {
    this.inputs = [];
    this.weights = [];
    this.output;
    this.bias = 1;

    // one more weight for bias
    for( var i = 0; i < inNumber + 1; i++ ) {
        this.weights.push( Math.random() );
    };

    this.activation = function( a ) {
        return( Math.tanh( a ) < .5 ? 1 : -1 );
    }

    this.feedForward = function() {
        var sum = 0;
        for( var i = 0; i < this.inputs.length; i++ ) {
            sum += this.inputs[i] * this.weights[i];
        }

        sum += this.bias * this.weights[this.weights.length - 1];

        this.output = this.activation( sum );
    }

    this.getOutput = function() {
        return this.output;
    }

    this.setInput= function( inputs ) {
        this.inputs = [];
        for( var i = 0; i < inputs.length; i++ ) {
            this.inputs.push( inputs[i] );
        }
    }

    this.adjustWeights = function( err ) {
        for( var i = 0; i < this.weights.length - 1; i++ ) {
            this.weights[i] += err * this.inputs[i];
        }
    }
}
