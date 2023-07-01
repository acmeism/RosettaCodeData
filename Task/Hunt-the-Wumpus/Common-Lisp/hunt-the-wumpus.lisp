;;; File: HuntTheWumpus.lisp


(setf *random-state* (make-random-state t))
(defvar numRooms 20)
(defparameter Cave #2A((1 4 7)   (0 2 9)   (1 3 11)   (2 4 13)  (0 3 5)
               (4 6 14)  (5 7 16)    (0 6 8)   (7 9 17)   (1 8 10)
               (9 11 18) (2 10 12) (11 13 19)  (3 12 14)  (5 13 15)
               (14 16 19) (6 15 17)  (8 16 18) (10 17 19) (12 15 18)))

(defun PrintInstructions()
    (print " Welcome to 'Hunt the Wumpus'! " )
    (print " The wumpus lives in a cave of 20 rooms. Each room has 3 tunnels leading to")
    (print " other rooms. (Look at a dodecahedron to see how this works - if you don't know")
    (print " what a dodecahedron is, ask someone). ")
    (print " Hazards: ")  (terpri)
    (print " Bottomless pits - two rooms have bottomless pits in them. If you go there, you ")
    (print " fall into the pit (& lose!) ")  (terpri)
    (print " Super bats - two other rooms have super bats.  If you go there, a bat grabs you")
    (print " and takes you to some other room at random. (Which may be troublesome). Once the")
    (print " bat has moved you, that bat moves to another random location on the map.")  (terpri)  (terpri)

    (print " Wumpus")
    (print " The wumpus is not bothered by hazards (he has sucker feet and is too big for a")
    (print " bat to lift).  Usually he is asleep.  Two things wake him up: you shooting an")
    (print " arrow or you entering his room. If the wumpus wakes he moves (p=.75) one room or ")
    (print " stays still (p=.25). After that, if he is where you are, he eats you up and you lose!")  (terpri)

    (print " You ")  (terpri)
    (print " Each turn you may move, save or shoot an arrow using the commands move, save, & shoot.")
    (print " Moving: you can move one room (thru one tunnel).")
    (print " Arrows: you have 3 arrows. You lose when you run out. You aim by telling the")
    (print " computer the rooms you want the arrow to go to.  If the arrow can't go that way")
    (print " (if no tunnel), the arrow will not fire.")

    (print " Warnings")
    (print " When you are one room away from a wumpus or hazard, the computer says:")

    (print " Wumpus: 'I smell a wumpus'")
    (print " Bat: 'Bats nearby'")
    (print " Pit: 'I feel a draft'") (terpri)
    (print "Press Y to return to the main menu.")
    (defvar again)
    (setq goBack (read))
    (if (string= goBack "Y")
      (StartGame)
    )

)

(defun PlacePlayer()
  (setq startingPosition 0)
  (setq currentRoom (Move 0))

)


(defun PlaceWumpus()
  (setq wumpusRoom (round (+ 1 (random 19))))
  (setq wumpusStart wumpusRoom)
)

(defun PlacePits()
  (setq pitRoom1 (round (+ 1 (random 19))))
  (setq pitRoom2 (round (+ 1 (random 19))))
)

(defun PlaceBats()
    (let ((validRoom T))
      (loop while validRoom
        do
          (setq batRoom1 (round (+ 1 (random 19))))
          (if (/= batRoom1 wumpusRoom)
            (setf validRoom nil))))
    (let ((validRoom T))
      (loop while validRoom
        do
          (setq batRoom2 (round (+ 1 (random 19))))
          (if (and (/= batRoom2 wumpusRoom) (/= batRoom2 batRoom1))
            (setf validRoom nil))))
    (setq bat1Start batRoom1)
    (setq bat2Start batRoom2)
)

(defun Move (newRoom)
  (return-from Move newRoom)
)

(defun IsValidMove (roomID)
  (if (< roomID 0)
    (return-from IsValidMove nil)
  )
  (if (> roomID numRooms)
    (return-from IsValidMove nil)
  )
  (if (eq (IsRoomAdjacent currentRoom roomID) nil)
    (return-from IsValidMove nil)
  )
  (return-from IsValidMove T)
)

(defun IsRoomAdjacent (roomA roomB)
  (loop for j from 0 to 2
    do
    (if (= (aref Cave roomA j) roomB)
      (return-from IsRoomAdjacent T)
    )
  )
  (return-from IsRoomAdjacent nil)
)

(defun InspectCurrentRoom()
  (if (= currentRoom wumpusRoom)
    (progn
      (print "The Wumpus ate you!!!")
      (print "LOSER!!!")
      (StartGame)
    )
    (if (or (= currentRoom batRoom1) (= currentRoom batRoom2))
      (progn
        (defvar roomBatsLeft currentRoom)
        (defvar validNewBatRoom nil)
        (defvar isBatRoom nil)
        (print "Snatched by superbats!!")
        (if (or (= currentRoom pitRoom1) (= currentRoom pitRoom2))
            (print "Luckily, the bats saved you from the bottomless pit!!")
        )
        (loop while (eq isBatRoom nil)
          do
            (defvar rand)
            (setq rand (round (+ 1 (random 19))))
            (setq currentRoom rand)
            (if (and (/= currentRoom batRoom1) (/= currentRoom batRoom2))
              (setf isBatRoom T)
            )
        )
        (setf isBatRoom nil)
        (print "The bats moved you to room")
        (print currentRoom)
        (InspectCurrentRoom)
        (if (= roomBatsLeft batRoom1)
          (loop while (not validNewBatRoom)
            do
               (setq batRoom1 (round (+ 1 (random 19))))
               (if (and (/= batRoom1 wumpusRoom) (/= batRoom1 currentRoom))
                 (setq validNewBatRoom T)
               )
          )
          (loop while (not validNewBatRoom)
            do
               (setq batRoom2 (round (+ 1 (random 19))))
               (if (and (/= batRoom2 wumpusRoom) (/= batRoom2 currentRoom))
                 (setq validNewBatRoom T)
               )
          )
        )
      )
      (if (or (= currentRoom pitRoom1) (= currentRoom pitRoom2))
        (progn
          (print "YYYIIIIIIEEEEE.... fell in a pit!!!")
          (print "GAME OVER LOSER!!!")
          (StartGame)
        )
        (progn

            (print "You are in room")
            (print currentRoom)
            (if (eq (IsRoomAdjacent currentRoom wumpusRoom) T)
              (print "You smell a horrid stench...")
            )
            (if (or (eq (IsRoomAdjacent currentRoom batRoom1) T) (eq (IsRoomAdjacent currentRoom batRoom2) T))
              (print "Bats nearby...")
            )
            (if (or (eq (IsRoomAdjacent currentRoom pitRoom1) T) (eq (IsRoomAdjacent currentRoom pitRoom2) T))
              (print "You feel a draft")
            )
            (print "Tunnels lead to rooms")
            (loop for i from 0 to 2 do
                (print (aref Cave currentRoom i))
            )
            (terpri)

        )
      )
    )
  )
)

(defun moveStartledwumpus(roomNum)
    (defvar rando)
    (setq rando (random 4))
    (if (/= rando 3)
      (setq wumpusRoom (aref Cave roomNum rando))
    )
)

(defun PreformAction(cmd)
  (defvar newRoom)
  (case cmd
    (1
      (print "Which room?")
      (setq newRoom (read))
      (if (eq (IsValidMove newRoom) T)
        (progn
          (setq currentRoom (Move newRoom))
          (InspectCurrentRoom)
        )
        (print "You cannot move there")
      )
    )
    (2
      (if (> numArrows 0)
        (progn
          (print "Which room?")
          (setq newRoom (read))
          (if (eq (IsValidMove newRoom) T)
            (progn
              (setq numArrows (- numArrows 1))
              (if (= newRoom wumpusRoom)
                (progn
                  (print "ARGH.. Splat!")
                  (print "Congratulations! You killed the Wumpus! You Win.")
                  (setq wumpusAlive nil)
                  (terpri)
                  ;;;(StartGame)
                )
                (progn
                  (print "Miss! but you startled the Wumpus")
                  (moveStartledwumpus wumpusRoom)
                  (print "Arrows Left")
                  (print numArrows)
                  (if (= wumpusRoom currentRoom)
                    (progn
                    (print "The wumpus attacked you! You've been killed.")
                    (print "Game Over!")
                    (terpri)
                    (StartGame)
                    )
                  )

                )
              )
            )
            (print "You cannot shoot there")
          )
        )
        (progn
           (print "You do not have any arrows!")
           ;;;(print "Game Over!")
           (terpri)
           ;;;(StartGame)


        )
      )
    )
    (3
      (print "Quiting the current game.")
      (setq playerAlive nil)
      (terpri)
      ;;;(StartGame)
    )
    (otherwise
      (print "You cannot do that. You can move, shoot, save or quit.")
    )
  )

)



(defun Playgame()
  (defvar choice)
  (defvar validChoice nil)

  (print "Running the game...")

  ;;;Initialize the game
  (PlaceWumpus)
  (PlaceBats)
  (PlacePits)
  (PlacePlayer)

  ;;;game set up
  (setq playerAlive T)
  (setq wumpusAlive T)
  (setq numArrows 3)

  ;;;InspectCurrentRoom
  (InspectCurrentRoom)

  ;(loop while (and (eq playerAlive T) (eq wumpusAlive T))
  ;  do
  (loop do
      (print "Enter an action choice")
      (print "1) Move")
      (print "2) Shoot")
      (print "3) Quit")
      (print ">>>")

;    (loop while (eq validChoice nil)
     (loop do
        (setq validChoice T)
        (defvar choice)
        (setq choice (read))
        (case choice
          (1 (PreformAction choice))
          (2 (PreformAction choice))
          (3 (PreformAction choice))
          (otherwise
            (setq validChoice nil)
            (print "Invalid choice. Please try again.")
          )
      )

  while (eq validChoice nil))
 while (and (eq playerAlive T) (eq wumpusAlive T)))
)


(defun StartGame()

  (let ((keepPlaying T))
    (loop while keepPlaying
      do
      (print "Welcome to Hunt The Wumpus.")
      (print "1) Play Game")
      (print "2) Print Instructions")
      (print "3) Quit")
      (let ((validChoice T))
        (loop while validChoice
          do
          (print "Please make a selection") (terpri)
          (defvar selection)
          (setq selection (read))
          (case selection
            (1 (Playgame))
            (2 (PrintInstructions))
            (3 (setf keepPlaying nil))
            (otherwise
              (setq validChoice nil)
              (print "Invalid choice. Please try again.")
            )

          )

          (setf validChoice nil)




        )

      )
      (setf keepPlaying nil)
    )
  )

)
(StartGame)
