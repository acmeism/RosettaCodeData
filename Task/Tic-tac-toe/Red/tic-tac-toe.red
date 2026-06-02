Red [
	Title: "Minimax Tic-Tac-Toe - with Alpha-Beta Pruning"
	Author: "hinjolicious"
	Resources: "Gemini AI, Rosetta Code examples, etc."
]

;ai:	"O"
;human:	"X"
player:	'human	; to indicate who play first
score:	#["X" 0 "O" 0 "-" 0]

; winning positions
win-lines: [
	1 2 3  4 5 6  7 8 9	 ; Rows
	1 4 7  2 5 8  3 6 9	 ; Columns
	1 5 9  3 5 7		 ; Diagonals
]

board: []

check-winner: func [b [block!] /local x y z w] [
	foreach [x y z] win-lines [
		if all [
			(w: b/(x)) <> " "
			w = b/(y)
			w = b/(z)
		][return w]
	]
	either find b " " [none] ["-"]
]

print-board: func [b [block!] /local c] [
	print ["" b/1 "|" b/2 "|" b/3]  print "---+---+---"
	print ["" b/4 "|" b/5 "|" b/6]  print "---+---+---"
	print ["" b/7 "|" b/8 "|" b/9 "^\"]
]

; --- 3. Optimized Minimax Simulation Engine (with Alpha-Beta Pruning) ---
; Added alpha-beta pruning to instantly cut off branches once a choice is proved poor.
minimax: func [
	b [block!] depth [integer!] is-maximizing [logic!] alpha [integer!] beta [integer!]
	/local winner score best-score i
] [
	winner: check-winner b
	if winner = "O"	[return 10 - depth]
	if winner = "X" [return depth - 10]
	if winner = "-"	[return 0]
	
	either is-maximizing [
		best-score: -1000
		repeat i 9 [
			if b/:i = " " [
				b/:i: "O"
				score: minimax b (depth + 1) false alpha beta
				b/:i: " "
				if score > best-score [best-score: score]
				if score > alpha [alpha: score]
				if beta <= alpha [break] ; Beta cutoff
			]
		]
		return best-score
	] [
		best-score: 1000
		repeat i 9 [
			if b/:i = " " [
				b/:i: "X"
				score: minimax b (depth + 1) true alpha beta
				b/:i: " "
				if score < best-score [best-score: score]
				if score < beta [beta: score]
				if beta <= alpha [break] ; Alpha cutoff
			]
		]
		return best-score
	]
]

find-best-move: func [b [block!] /local best-val best-move score i] [
	best-val: -1000
	best-move: -1
	repeat i 9 [
		if b/:i = " " [
			b/:i: "O"
			score: minimax b 0 false -1000 1000
			b/:i: " "
			print ["Move" i " --> Score:" score]
			if score > best-val [
				best-val: score
				best-move: i
			]
		]
	]
	return best-move
]

;first-move: yes

human-play: does [
	print-board board
	until [
		move-str: ask "Your move (1-9): "
		move: attempt [to integer! move-str]
		either all [integer? move move >= 1 move <= 9  board/:move = " "] [
			board/:move: "X"
			true
		][
			print "Invalid move! Try again."
			false
		]
	]
]

;first-move: yes

ai-play: does [
	print ["AI thinking..."]
	either first-move [ ; use opening move!
		print ["Use opening move!"]
		ai-move: either board/5 = " " [5][1]
		first-move: no
	] [
		ai-move: find-best-move board
	]
	if ai-move <> -1 [board/:ai-move: "O"]
	print ["Best move ==>" ai-move "!"]	
]	

play: does [
	insert/dup clear board " " 9	; initialize board
	
	first-move: yes	; to indicate if AI move first
	until [
		either player = 'human [
			human-play
			if check-winner board [break]
			ai-play
		][
			ai-play
			if check-winner board [break]
			human-play
		]
		not none? check-winner board
	]
	
	print-board board
	print ["GAME OVER! Result:" winner: check-winner board]
	if winner <> 'none [score/:winner: score/:winner + 1]
	print ["Score: Human =" score/"X" "AI =" score/"O" "Draw =" score/"-" "^/"]
	player: either player = 'human ['ai] ['human]
]

print "=== TIC-TAC-TOE - OPTIMIZED MINIMAX ==="
forever [play]
