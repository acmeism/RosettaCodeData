var board, zx, zy, clicks, possibles, clickCounter, oldzx = -1, oldzy = -1;
function getPossibles() {
    var ii, jj, cx = [-1, 0, 1, 0], cy = [0, -1, 0, 1];
    possibles = [];
    for( var i = 0; i < 4; i++ ) {
        ii = zx + cx[i]; jj = zy + cy[i];
        if( ii < 0 || ii > 3 || jj < 0 || jj > 3 ) continue;
        possibles.push( { x: ii, y: jj } );
    }
}
function updateBtns() {
    var b, v, id;
    for( var j = 0; j < 4; j++ ) {
        for( var i = 0; i < 4; i++ ) {
            id = "btn" + ( i + j * 4 );
            b = document.getElementById( id );
            v = board[i][j];
            if( v < 16 ) {
                b.innerHTML = ( "" + v );
                b.className = "button"
            }
            else {
                b.innerHTML = ( "" );
                b.className = "empty";
            }
        }
    }
    clickCounter.innerHTML = "Clicks: " + clicks;
}
function shuffle() {
    var v = 0, t;
    do {
        getPossibles();
        while( true ) {
            t = possibles[Math.floor( Math.random() * possibles.length )];
            console.log( t.x, oldzx, t.y, oldzy )
            if( t.x != oldzx || t.y != oldzy ) break;
        }
        oldzx = zx; oldzy = zy;
        board[zx][zy] = board[t.x][t.y];
        zx = t.x; zy = t.y;
        board[zx][zy] = 16;
    } while( ++v < 200 );
}
function restart() {
    shuffle();
    clicks = 0;
    updateBtns();
}
function checkFinished() {
    var a = 0;
    for( var j = 0; j < 4; j++ ) {
        for( var i = 0; i < 4; i++ ) {
            if( board[i][j] < a ) return false;
            a = board[i][j];
        }
    }
    return true;
}
function btnHandle( e ) {
    getPossibles();
    var c = e.target.i, r = e.target.j, p = -1;
    for( var i = 0; i < possibles.length; i++ ) {
        if( possibles[i].x == c && possibles[i].y == r ) {
            p = i;
            break;
        }
    }
    if( p > -1 ) {
        clicks++;
        var t = possibles[p];
        board[zx][zy] = board[t.x][t.y];
        zx = t.x; zy = t.y;
        board[zx][zy] = 16;
        updateBtns();
        if( checkFinished() ) {
            setTimeout(function(){
                alert( "WELL DONE!" );
                restart();
            }, 1);
        }
    }
}
function createBoard() {
    board = new Array( 4 );
    for( var i = 0; i < 4; i++ ) {
        board[i] = new Array( 4 );
    }
    for( var j = 0; j < 4; j++ ) {
        for( var i = 0; i < 4; i++ ) {
            board[i][j] = ( i + j * 4 ) + 1;
        }
    }
    zx = zy = 3; board[zx][zy] = 16;
}
function createBtns() {
    var b, d = document.createElement( "div" );
    d.className += "board";
    document.body.appendChild( d );
    for( var j = 0; j < 4; j++ ) {
        for( var i = 0; i < 4; i++ ) {
            b = document.createElement( "button" );
            b.id = "btn" + ( i + j * 4 );
            b.i = i; b.j = j;
            b.addEventListener( "click", btnHandle, false );
            b.appendChild( document.createTextNode( "" ) );
            d.appendChild( b );
        }
    }
    clickCounter = document.createElement( "p" );
    clickCounter.className += "txt";
    document.body.appendChild( clickCounter );
}
function start() {
    createBtns();
    createBoard();
    restart();
}
