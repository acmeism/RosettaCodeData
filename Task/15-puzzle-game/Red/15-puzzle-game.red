Red [Needs: 'view]
system/view/screens/1/pane/-1/visible?: false ;; suppress console window
;; because this code is heavily influenced / (copied from ... )
;; by the rebol version ( which actually works with red as well with
;; some minimal changes ) i added some comments to make the
;; code more readable...

;;-----------------------------------------
;; check, if puzzle is solved, OK button closes program
;;-----------------------------------------
check: does [
;; the text on each tile must be equal to its position:
  repeat pos 15 [ unless pos = to-integer lay/pane/:pos/text  [exit] ]
  view/flags [  title "SuCCeSS"
                 text "You solved the puzzle ! "  button "OK"  [quit]
    ] [modal popup]
]
;;--------------------------------------
;; actually only changes text / Number on tile / button
;;---------------------------------------
changeTiles: func [ f ][
  ;; this is tricky, check if e(mpty) button is one in of the
  ;; four valid positions , by simply subtracting their offsets...else exit ( no change)
  unless find  [ 0x52 0x-52 52x0 -52x0 ] f/offset - e/offset [return false]
  e/text: f/text  ;; empty button gets Number from clicked button
  e/visible?: true  ;; empty gets visible
  f/visible?: false ;; clicked button gets invisible
  e: f    ;; e(mpty) refers now to clicked button
  return true ;; true - change has happened
]
;;-----------------------------------------
;; function which is executed, when button is clicked
;; argument is face - button
;;-------------------------------------
bClicked: func [f][   if changeTiles f [check] ]

;; define the window:
;; style is a prototype definition for a button element
win:   [ title "15 Puzzle"
		backdrop silver
		style btn: button 40x40  [bClicked face] font-size 15 bold
]
;; generate 1..15 buttons with number
repeat nr 15 [
     repend win  [ 'btn form nr ] ;; repend reduces and then appends..
     if  0 = mod nr 4  [  append win  'return ] ;; "carriage return" in window after 4 buttons
	]
  ;; append empty / hidden button no 16 and return/quit button:
	append win [ e: btn "16" hidden return  button "Quit" [quit]]

lay: layout win
;; define win as layout, so  each button can now be addressed as
;; layout/pane/index ( 1..15 - redbol is 1 based )

flip: 0
;; start random generator, otherwise we always get the same puzzle
random/seed now/time/precise
;; lets flip random tiles a few times to initialize the puzzle
;; ( actually numbers < 100 are quite easy to solve )

while [ flip < 40 ] [ if changeTiles lay/pane/(random 16)  [ flip:  flip  + 1 ]  ]

;; show the window...
view  lay
