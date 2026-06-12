var sel, again, check, score, done, atoms, guesses, beamCnt, brdSize;

function updateScore( s ) {
    score += s || 0;
    para.innerHTML = "Score: " + score;
}
function checkIt() {
    check.className = "hide";
    again.className = "again";
    done = true;
    var b, id;
    for( var j = 0; j < brdSize; j++ ) {
        for( var i = 0; i < brdSize; i++ ) {
            if( board[i][j].H ) {
                b = document.getElementById( "atom" + ( i + j * brdSize ) );
                b.innerHTML = "&#x2688;";
                if( board[i][j].T ) {
                    b.style.color = "#0a2";
                } else {
                    b.style.color = "#f00";
                     updateScore( 5 );
                }
            }
        }
    }
}
function isValid( n ) {
    return n > -1 && n < brdSize;
}
function stepBeam( sx, sy, dx, dy ) {
    var s = brdSize - 2
    if( dx ) {
        if( board[sx][sy].H ) return {r:"H", x:sx, y:sy};
        if( ( (sx == 1 && dx == 1) || (sx == s && dx == -1) ) && ( ( sy > 0 && board[sx][sy - 1].H ) ||
            ( sy < s && board[sx][sy + 1].H ) ) ) return {r:"R", x:sx, y:sy};
        if( isValid( sx + dx ) ) {
            if( isValid( sy - 1 ) && board[sx + dx][sy - 1].H ) {
                dx = 0; dy = 1;
            }
            if( isValid( sy + 1 ) && board[sx + dx][sy + 1].H ) {
                dx = 0; dy = -1;
            }
            sx += dx;
            return stepBeam( sx, sy, dx, dy );
        } else {
            return {r:"O", x:sx, y:sy};
        }
    } else {
        if( board[sx][sy].H ) return {r:"H", x:sx, y:sy};
        if( ( (sy == 1 && dy == 1) || (sy == s && dy == -1) ) && ( ( sx > 0 && board[sx - 1][sy].H ) ||
           ( sx < s && board[sx + 1][sy].H ) ) ) return {r:"R", x:sx, y:sy};
        if( isValid( sy + dy ) ) {
            if( isValid( sx - 1 ) && board[sx - 1][sy + dy].H ) {
                dy = 0; dx = 1;
            }
            if( isValid( sx + 1 ) && board[sx + 1][sy + dy].H ) {
                dy = 0; dx = -1;
            }
            sy += dy;
            return stepBeam( sx, sy, dx, dy );
        } else {
            return {r:"O", x:sx, y:sy};
        }
    }
}
function fireBeam( btn ) {
    var sx = btn.i, sy = btn.j, dx = 0, dy = 0;

    if( sx == 0 || sx == brdSize - 1 ) dx = sx == 0 ? 1 : - 1;
    else if( sy == 0 || sy == brdSize - 1 ) dy = sy == 0 ? 1 : - 1;
    var s = stepBeam( sx + dx, sy + dy, dx, dy );
    switch( s.r ) {
        case "H":
            btn.innerHTML = "H";
            updateScore( 1 );
            break;
        case "R":
            btn.innerHTML = "R";
            updateScore( 1 );
            break;
        case "O":
            if( s.x == sx && s.y == sy ) {
                btn.innerHTML = "R";
                updateScore( 1 );
            }
            else {
                var b = document.getElementById( "fire" + ( s.x + s.y * brdSize ) );
                btn.innerHTML = "" + beamCnt;
                b.innerHTML = "" + beamCnt;
                beamCnt++;
                updateScore( 2 );
            }
    }
}
function setAtom( btn ) {
    if( done ) return;

    var b = document.getElementById( "atom" + ( btn.i + btn.j * brdSize ) );
    if( board[btn.i][btn.j].T == 0 && guesses < atoms ) {
        board[btn.i][btn.j].T = 1;
        guesses++;
        b.innerHTML = "&#x2688;";
    } else if( board[btn.i][btn.j].T == 1 && guesses > 0 ) {
        board[btn.i][btn.j].T = 0;
        guesses--;
        b.innerHTML = " ";
    }
    if( guesses == atoms ) check.className = "check";
    else check.className = "hide";
}
function startGame() {
    score = 0;
    updateScore();
    check.className = again.className = "hide";
    var e = document.getElementById( "mid" );
    if( e.firstChild ) e.removeChild( e.firstChild );

    brdSize = sel.value;
    done = false;

    if( brdSize < 5 ) return;

    var brd = document.createElement( "div" );
    brd.id = "board";
    brd.style.height = brd.style.width = 5.2 * brdSize + "vh"
    e.appendChild( brd );

    var b, c, d;
    for( var j = 0; j < brdSize; j++ ) {
        for( var i = 0; i < brdSize; i++ ) {
            b = document.createElement( "button" );
            b.i = i; b.j = j;
            if( j == 0 && i == 0 || j == 0 && i == brdSize - 1 ||
                j == brdSize - 1 && i == 0 || j == brdSize - 1 && i == brdSize - 1 ) {
                b.className = "corner";
            } else {
                if( j == 0 || j == brdSize - 1 || i == 0 || i == brdSize - 1 ) {
                    b.className = "fire";
                    b.id = "fire" + ( i + j * brdSize );
                } else {
                    b.className = "atom";
                    b.id = "atom" + ( i + j * brdSize );
                }
                b.addEventListener( "click",
                    function( e ) {
                        if( e.target.className == "fire" && e.target.innerHTML == " " ) fireBeam( e.target );
                        else if( e.target.className == "atom" ) setAtom( e.target );
                    }, false );
            }
            b.appendChild( document.createTextNode( " " ) );
            brd.appendChild( b );
        }
    }

    board = new Array( brdSize );
    for( var j = 0; j < brdSize; j++ ) {
        board[j] = new Array( brdSize );
        for( i = 0; i < brdSize; i++ ) {
            board[j][i] = {H: 0, T: 0};
        }
    }

    guesses = 0; beamCnt = 1;
    atoms = brdSize == 7 ? 3 : brdSize == 10 ? 4 : 4 + Math.floor( Math.random() * 5 );

    var s = brdSize - 2, i, j;
    for( var k = 0; k < atoms; k++ ) {
        while( true ) {
            i = 1 + Math.floor( Math.random() * s );
            j = 1 + Math.floor( Math.random() * s );
            if( board[i][j].H == 0 ) break;
        }
        board[i][j].H = 1;
    }
}
function init() {
    sel = document.createElement( "select");
    sel.options.add( new Option( "5 x 5 [3 atoms]", 7 ) );
    sel.options.add( new Option( "8 x 8 [4 atoms]", 10 ) );
    sel.options.add( new Option( "10 x 10 [4 - 8 atoms]", 12 ) );
    sel.addEventListener( "change", startGame, false );
    document.getElementById( "top" ).appendChild( sel );

    check = document.createElement( "button" );
    check.appendChild( document.createTextNode( "Check it!" ) );
    check.className = "hide";
    check.addEventListener( "click", checkIt, false );

    again = document.createElement( "button" );
    again.appendChild( document.createTextNode( "Again" ) );
    again.className = "hide";
    again.addEventListener( "click", startGame, false );

    para = document.createElement( "p" );
    para.className = "txt";
    var d = document.getElementById( "bot" );

    d.appendChild( para );
    d.appendChild( check );
    d.appendChild( again );
    startGame();
}
