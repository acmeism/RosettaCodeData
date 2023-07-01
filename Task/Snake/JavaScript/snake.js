const L = 1, R = 2, D = 4, U = 8;
var block = 24, wid = 30, hei = 20, frameR = 7, fruit, snake;
function Snake() {
    this.length = 1;
    this.alive = true;
    this.pos = createVector( 1, 1 );
    this.posArray = [];
    this.posArray.push( createVector( 1, 1 ) );
    this.dir = R;
    this.draw = function() {
        fill( 130, 190, 0 );
        var pos, i = this.posArray.length - 1, l = this.length;
        while( true ){
            pos = this.posArray[i--];
            rect( pos.x * block, pos.y * block, block, block );
            if( --l == 0 ) break;
        }
    }
    this.eat = function( frut ) {
        var b = this.pos.x == frut.x && this.pos.y == frut.y;
        if( b ) this.length++;
        return b;
    }
    this.overlap = function() {
        var len = this.posArray.length - 1;
        for( var i = len; i > len - this.length; i-- ) {
            tp = this.posArray[i];
            if( tp.x === this.pos.x && tp.y === this.pos.y ) return true;
        }
        return false;
    }
    this.update = function() {
        if( !this.alive ) return;
        switch( this.dir ) {
            case L:
                this.pos.x--; if( this.pos.x < 1 ) this.pos.x = wid - 2;
            break;
            case R:
                this.pos.x++; if( this.pos.x > wid - 2 ) this.pos.x = 1;
            break;
            case U:
                this.pos.y--; if( this.pos.y < 1 ) this.pos.y = hei - 2;
            break;
            case D:
                this.pos.y++; if( this.pos.y > hei - 2 ) this.pos.y = 1;
            break;
        }
        if( this.overlap() ) { this.alive = false; } else {
            this.posArray.push( createVector( this.pos.x, this.pos.y ) );
            if( this.posArray.length > 5000 ) { this.posArray.splice( 0, 1 ); }
        }
    }
}
function Fruit() {
    this.fruitTime = true;
    this.pos = createVector();
    this.draw = function() {
        fill( 200, 50, 20 );
        rect( this.pos.x * block, this.pos.y * block, block, block );
    }

    this.setFruit = function() {
        this.pos.x = floor( random( 1, wid - 1 ) );
        this.pos.y = floor( random( 1, hei - 1 ) );
        this.fruitTime = false;
    }
}
function setup() {
    createCanvas( block * wid, block * hei );
    noStroke(); frameRate( frameR );
    snake = new Snake();fruit = new Fruit();
}
function keyPressed() {
    switch( keyCode ) {
        case LEFT_ARROW: snake.dir = L; break;
        case RIGHT_ARROW: snake.dir = R; break;
        case UP_ARROW: snake.dir = U; break;
        case DOWN_ARROW: snake.dir = D;
    }
}
function draw() {
    background( color( 0, 0x22, 0 ) );
    fill( 20, 50, 120 );
    for( var i = 0; i < wid; i++ ) {
        rect( i * block, 0, block, block );
        rect( i * block, height - block, block, block );
    }
    for( var i = 1; i < hei - 1; i++ ) {
        rect( 1, i * block, block, block );
        rect( width - block, i * block, block, block );
    }
    if( fruit.fruitTime ) {
        fruit.setFruit();
        frameR += .2;
        frameRate( frameR );
    }
    fruit.draw();
    snake.update();
    if( snake.eat( fruit.pos ) ) {
        fruit.fruitTime = true;
    }
    snake.draw();
    fill( 200 );
    textStyle( BOLD ); textAlign( RIGHT ); textSize( 120 );
    text( ""+( snake.length - 1 ), 690, 440 );
    if( !snake.alive ) text( "THE END", 630, 250 );
}
