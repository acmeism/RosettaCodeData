<?php
const BOARD_NUM = 9;
const ROW_NUM = 3;
$EMPTY_BOARD_STR = str_repeat('.', BOARD_NUM);

function isGameOver($board, $pin) {
	$pat =
		'/X{3}|' . //Horz
		'X..X..X..|' . //Vert Left
		'.X..X..X.|' . //Vert Middle
		'..X..X..X|' . //Vert Right
		'..X.X.X..|' . //Diag TL->BR
		'X...X...X|' . //Diag TR->BL
		'[^\.]{9}/i'; //Cat's game
	if ($pin == 'O') $pat = str_replace('X', 'O', $pat);
	return preg_match($pat, $board);
}

//Start
$boardStr = isset($_GET['b'])? $_GET['b'] : $EMPTY_BOARD_STR;
$turn = substr_count($boardStr, '.')%2==0? 'O' : 'X';
$oppTurn = $turn == 'X'? 'O' : 'X';
$gameOver = isGameOver($boardStr, $oppTurn);

//Display board
echo '<style>';
echo 'td {width: 200px; height: 200px; text-align: center; }';
echo '.pin {font-size:72pt; text-decoration:none; color: black}';
echo '.pin.X {color:red}';
echo '.pin.O {color:blue}';
echo '</style>';
echo '<table border="1">';
$p = 0;
for ($r = 0; $r < ROW_NUM; $r++) {
	echo '<tr>';
	for ($c = 0; $c < ROW_NUM; $c++) {
		$pin = $boardStr[$p];
		
		echo '<td>';		
		if ($gameOver || $pin != '.') echo '<span class="pin ', $pin, '">', $pin, '</span>'; //Occupied
		else { //Available
			$boardDelta = $boardStr;
			$boardDelta[$p] = $turn;		
			echo '<a class="pin ', $pin, '" href="?b=', $boardDelta, '">';
			echo $boardStr[$p];
			echo '</a>';
		}
		
		echo '</td>';	
		$p++;
	}
	echo '</tr>';
	echo '<input type="hidden" name="b" value="', $boardStr, '"/>';
}
echo '</table>';
echo '<a href="?b=', $EMPTY_BOARD_STR, '">Reset</a>';
if ($gameOver) echo '<h1>Game Over!</h1>';
