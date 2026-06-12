var board, playBtn, turn, memory = [], lastMove = {brd: "", mvi: 0},
    clicks = {first: null, second: null}, win = {c: 0, p: 0}, score;

function getPossibles() {
    var pos = [], tp = turn == 0 ? "W" : "B", gp = turn == 0 ? "B" : "W";
	
    for( var j = 0; j < 3; j++ ) {
        var jj = j + (turn == 0 ? -1 : 1);
        if( jj < 3 && jj > -1 ) {
            for( var i = 0; i < 3; i++ ) {
                if( board[i][j] == tp ) {
                    for( var k = -1; k < 2; k++ ) {
                        if(i + k > -1 && i + k < 3 &&
                            ((board[i + k][jj] == " " && i + k == i) || (board[i + k][jj] == gp && i + k != i))) {
                            pos.push( {f: i + j * 3, t: i + k + jj * 3});
                        }
                    }
                }
            }
        }
    }
    return pos;
}
function computerMoves() {
    var brd = getBoard(), mvs, needSave = false;

	for( var i = 0; i < memory.length; i++ ) {
        if( memory[i].board == brd ) {
            mvs = memory[i].moves;
            break;
        }
    }
	
    if( !mvs ) {
        mvs = getPossibles();
        needSave = true;
    }
    if( mvs.length == 0 ) return 0;

	var idx = Math.floor( Math.random() * mvs.length );
	lastMove.brd = brd;
	lastMove.mvi = idx;
	var i = mvs[idx].f % 3, j = Math.floor( mvs[idx].f / 3 ),
		ii = mvs[idx].t % 3, jj = Math.floor( mvs[idx].t / 3 );
	board[i][j] = " "; board[ii][jj] = "B";

    if( needSave ) {
        memory.push( {board: brd, moves: mvs} );
    }
	updateBtns();
    return -1;
}
function getBoard() {
    var str = "";
    for( var j = 0; j < 3; j++ ) {
        for( var i = 0; i < 3; i++ ) {
            str += board[i][j];
        }
    }
    return str;
}
function updateScore() {
	score.innerHTML = "Player: " + win.p + " Computer: " + win.c;
}
function finish( r ) {
	var str = "The Computer wins!";
	if( r == 0 ) {
		str = "You win!";
		win.p++;
		for( var i = 0; i < memory.length; i++ ) {
			if( memory[i].board == lastMove.brd ) {
				memory[i].moves.splice( lastMove.mvi, 1 );
				break;
			}
		}
	} else {
		win.c++;
	}
	playBtn.innerHTML = str + "<br />Click to play.";
	playBtn.className = "button long"
	updateScore();
}
function checkFinished() {
    if( getPossibles().length < 1 ) return turn == 0 ? 1 : 0;

    for( var i = 0; i < 3; i++ ) {
        if( board[i][0] == "W" ) return 0;
        if( board[i][2] == "B" ) return 1;
    }
	
    var w = 0, b = 0;
    for( var j = 0; j < 3; j++ ) {
        for( var i = 0; i < 3; i++ ) {
            if( board[i][j] == "W" ) w++;
            if( board[i][j] == "B" ) b++;
        }
    }
    if( w == 0 ) return 1;
    if( b == 0 ) return 0;
    return -1;
}
function nextPlayer() {
	var r;
	updateBtns();
	turn = turn == 0 ? 1 : 0;
	r = checkFinished();
	
	if( r > -1 ) {
		finish( r );
	} else {
		if( turn == 1 ) {
			r = computerMoves();
			if( r < 0 ) nextPlayer();
			else finish( r );
		}
	}
}
function search( o, arr ) {
	for( var i = 0; i < arr.length; i++ ) {
		if( o.f == arr[i].f && o.t == arr[i].t ) return i;
	}
	return -1;
}
function btnHandle( e ) {
    if( turn > 0 ) return;
    if( clicks.first == null && e.target.firstChild.data == "W" ) {
        clicks.first = e.target;
        clicks.first.className += " marked"
    } else if( clicks.first != null && e.target.firstChild.data == "W" ) {
		clicks.first.className = clicks.first.className.split(" ")[0];
        clicks.first = clicks.second = null;
	} else if( clicks.first != null && ( e.target.firstChild.data == " " ||
                                         e.target.firstChild.data == "B" ) ) {
        clicks.second = e.target;
        var moves = getPossibles( turn ),
            i = clicks.first.i, ii = clicks.second.i,
            j = clicks.first.j, jj = clicks.second.j,
            obj = {f: i + j * 3, t: ii + jj * 3};
        if( search( obj, moves ) > -1 ) {
            board[i][j] = " "; board[ii][jj] = "W";
			clicks.first.className = clicks.first.className.split(" ")[0];
			clicks.first = clicks.second = null;
			nextPlayer();
		}
    }
}
function updateBtns() {
    var b, v;
    for( var j = 0; j < 3; j++ ) {
        for( var i = 0; i < 3; i++ ) {
            b = document.getElementById( "btn" + ( i + j * 3 ) );
            b.innerHTML = ( board[i][j] );
        }
    }
}
function restart() {
    turn = 0;
    createBoard();
    updateBtns();
	playBtn.className += " hide";
}
function createBoard() {
    board = new Array( 3 );
    for( var i = 0; i < 3; i++ ) {
        board[i] = new Array( 3 );
    }
    for( var j = 0; j < 3; j++ ) {
        for( var i = 0; i < 3; i++ ) {
            board[i][j] = j == 0 ? "B" : j == 2 ? "W" : " ";
        }
    }
}
function createBtns() {
    var b, d = document.createElement( "div" ), v = false;
    d.className += "board";
    document.body.appendChild( d );
    for( var j = 0; j < 3; j++ ) {
        for( var i = 0; i < 3; i++ ) {
            b = document.createElement( "button" );
            b.id = "btn" + ( i + j * 3 );
            b.i = i; b.j = j;
            b.addEventListener( "click", btnHandle, false );
            b.appendChild( document.createTextNode( "" ) );
            d.appendChild( b );
            if( v ) b.className = "button"
            else  b.className = "empty";
            v = !v;
        }
    }
    playBtn = document.createElement( "button" );
    playBtn.className = "button long hide";
	playBtn.addEventListener( "click", restart, false );
	score = document.createElement( "p" );
    score.className = "txt";
	d.appendChild( score );
    d.appendChild( playBtn );
    updateScore();
}
function init() {
    createBtns();
    restart();
}
