 IDENTIFICATION DIVISION.
 PROGRAM-ID. AVL-TREE.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

*>--------------------------------------------------------
*> Node pool - array-based tree storage (0 = null)
*>--------------------------------------------------------
 01  WS-NODE-COUNT            PIC 9(4) VALUE 0.
 01  WS-ROOT                  PIC 9(4) VALUE 0.

 01  WS-NODE-TABLE.
     05  WS-NODES OCCURS 1000 TIMES.
         10  WS-N-KEY         PIC S9(8) VALUE 0.
         10  WS-N-BAL         PIC S9(4) VALUE 0.
         10  WS-N-HGT         PIC S9(4) VALUE 0.
         10  WS-N-LEFT        PIC 9(4)  VALUE 0.
         10  WS-N-RIGHT       PIC 9(4)  VALUE 0.
         10  WS-N-PARENT      PIC 9(4)  VALUE 0.

*>--------------------------------------------------------
*> Subroutine parameters and return values
*>--------------------------------------------------------
 01  WS-INSERT-KEY            PIC S9(8).
 01  WS-INSERT-OK             PIC 9 VALUE 0.
     88  INSERT-SUCCESS       VALUE 1.
     88  INSERT-FAILURE       VALUE 0.

 01  WS-DELETE-KEY            PIC S9(8).

 01  WS-NEW-IDX               PIC 9(4).
 01  WS-ALLOC-KEY             PIC S9(8).
 01  WS-ALLOC-PARENT          PIC 9(4).

 01  WS-ROT-A                 PIC 9(4).
 01  WS-ROT-B                 PIC 9(4).
 01  WS-ROT-RESULT            PIC 9(4).

 01  WS-HGT-IDX              PIC 9(4).
 01  WS-HGT-RESULT           PIC S9(4).

 01  WS-SETBAL-IDX           PIC 9(4).

 01  WS-RB-IDX                PIC 9(4).

*>--------------------------------------------------------
*> Internal working variables
*>--------------------------------------------------------
 01  WS-CURR-IDX              PIC 9(4).
 01  WS-PARENT-IDX            PIC 9(4).
 01  WS-GO-LEFT               PIC 9 VALUE 0.
     88  GOING-LEFT           VALUE 1.
     88  GOING-RIGHT          VALUE 0.

 01  WS-TEMP-IDX              PIC 9(4).
 01  WS-HEIGHT-LL             PIC S9(4).
 01  WS-HEIGHT-LR             PIC S9(4).
 01  WS-HEIGHT-RL             PIC S9(4).
 01  WS-HEIGHT-RR             PIC S9(4).
 01  WS-HGT-LEFT             PIC S9(4).
 01  WS-HGT-RIGHT            PIC S9(4).
 01  WS-MAX-HGT              PIC S9(4).

 01  WS-DEL-NODE              PIC 9(4).
 01  WS-DEL-CHILD             PIC 9(4).
 01  WS-DEL-PARENT            PIC 9(4).
 01  WS-SEARCH-IDX            PIC 9(4).

*>--------------------------------------------------------
*> Print balance - iterative in-order traversal stack
*>--------------------------------------------------------
 01  WS-PB-CURR              PIC 9(4).
 01  WS-PB-TOP               PIC 9(4) VALUE 0.
 01  WS-PB-STACK.
     05  WS-PB-ITEMS OCCURS 1000 TIMES
                             PIC 9(4).
 01  WS-DISPLAY-BAL          PIC -9.

*>--------------------------------------------------------
*> Loop counter
*>--------------------------------------------------------
 01  WS-I                    PIC S9(8).

 PROCEDURE DIVISION.

*>========================================================
 MAIN-PROGRAM.
*>========================================================
     DISPLAY "Inserting values 1 to 10"
     PERFORM VARYING WS-I FROM 1 BY 1
         UNTIL WS-I > 9
         MOVE WS-I TO WS-INSERT-KEY
         PERFORM INSERT-NODE
     END-PERFORM

     DISPLAY "Printing balance: " WITH NO ADVANCING
     PERFORM PRINT-BALANCE
     DISPLAY " "

     STOP RUN
     .

*>========================================================
*> ALLOCATE-NODE
*> Input:  WS-ALLOC-KEY, WS-ALLOC-PARENT
*> Output: WS-NEW-IDX
*>========================================================
 ALLOCATE-NODE.
     ADD 1 TO WS-NODE-COUNT
     MOVE WS-NODE-COUNT TO WS-NEW-IDX
     MOVE WS-ALLOC-KEY    TO WS-N-KEY(WS-NEW-IDX)
     MOVE 0               TO WS-N-BAL(WS-NEW-IDX)
     MOVE 0               TO WS-N-HGT(WS-NEW-IDX)
     MOVE 0               TO WS-N-LEFT(WS-NEW-IDX)
     MOVE 0               TO WS-N-RIGHT(WS-NEW-IDX)
     MOVE WS-ALLOC-PARENT TO WS-N-PARENT(WS-NEW-IDX)
     .

*>========================================================
*> INSERT-NODE
*> Input:  WS-INSERT-KEY
*> Output: WS-INSERT-OK (1=success, 0=duplicate)
*>========================================================
 INSERT-NODE.
     SET INSERT-FAILURE TO TRUE

     IF WS-ROOT = 0
         MOVE WS-INSERT-KEY TO WS-ALLOC-KEY
         MOVE 0 TO WS-ALLOC-PARENT
         PERFORM ALLOCATE-NODE
         MOVE WS-NEW-IDX TO WS-ROOT
         SET INSERT-SUCCESS TO TRUE
     ELSE
         MOVE WS-ROOT TO WS-CURR-IDX
         PERFORM INSERT-SEARCH
             UNTIL WS-CURR-IDX = 0
             OR INSERT-SUCCESS
     END-IF
     .

 INSERT-SEARCH.
     IF WS-N-KEY(WS-CURR-IDX) = WS-INSERT-KEY
         SET INSERT-FAILURE TO TRUE
         MOVE 0 TO WS-CURR-IDX
     ELSE
         MOVE WS-CURR-IDX TO WS-PARENT-IDX
         IF WS-N-KEY(WS-CURR-IDX) > WS-INSERT-KEY
             SET GOING-LEFT TO TRUE
             MOVE WS-N-LEFT(WS-CURR-IDX)
                 TO WS-CURR-IDX
         ELSE
             SET GOING-RIGHT TO TRUE
             MOVE WS-N-RIGHT(WS-CURR-IDX)
                 TO WS-CURR-IDX
         END-IF

         IF WS-CURR-IDX = 0
             MOVE WS-INSERT-KEY TO WS-ALLOC-KEY
             MOVE WS-PARENT-IDX TO WS-ALLOC-PARENT
             PERFORM ALLOCATE-NODE
             IF GOING-LEFT
                 MOVE WS-NEW-IDX
                     TO WS-N-LEFT(WS-PARENT-IDX)
             ELSE
                 MOVE WS-NEW-IDX
                     TO WS-N-RIGHT(WS-PARENT-IDX)
             END-IF
             MOVE WS-PARENT-IDX TO WS-RB-IDX
             PERFORM REBALANCE
             SET INSERT-SUCCESS TO TRUE
         END-IF
     END-IF
     .

*>========================================================
*> DELETE-BY-KEY
*> Input: WS-DELETE-KEY
*>========================================================
 DELETE-BY-KEY.
     IF WS-ROOT NOT = 0
         MOVE WS-ROOT TO WS-SEARCH-IDX
         PERFORM DELETE-KEY-SEARCH
             UNTIL WS-SEARCH-IDX = 0
     END-IF
     .

 DELETE-KEY-SEARCH.
     MOVE WS-SEARCH-IDX TO WS-DEL-NODE
     IF WS-DELETE-KEY >= WS-N-KEY(WS-DEL-NODE)
         MOVE WS-N-RIGHT(WS-DEL-NODE)
             TO WS-SEARCH-IDX
     ELSE
         MOVE WS-N-LEFT(WS-DEL-NODE)
             TO WS-SEARCH-IDX
     END-IF

     IF WS-DELETE-KEY = WS-N-KEY(WS-DEL-NODE)
         PERFORM DELETE-NODE
         MOVE 0 TO WS-SEARCH-IDX
     END-IF
     .

*>========================================================
*> DELETE-NODE (iterative replacement of Java recursion)
*> Input: WS-DEL-NODE
*>========================================================
 DELETE-NODE.
*>    Swap key with predecessor/successor until leaf
     PERFORM UNTIL WS-N-LEFT(WS-DEL-NODE) = 0
         AND WS-N-RIGHT(WS-DEL-NODE) = 0

         IF WS-N-LEFT(WS-DEL-NODE) NOT = 0
             MOVE WS-N-LEFT(WS-DEL-NODE)
                 TO WS-DEL-CHILD
             PERFORM UNTIL
                 WS-N-RIGHT(WS-DEL-CHILD) = 0
                 MOVE WS-N-RIGHT(WS-DEL-CHILD)
                     TO WS-DEL-CHILD
             END-PERFORM
         ELSE
             MOVE WS-N-RIGHT(WS-DEL-NODE)
                 TO WS-DEL-CHILD
             PERFORM UNTIL
                 WS-N-LEFT(WS-DEL-CHILD) = 0
                 MOVE WS-N-LEFT(WS-DEL-CHILD)
                     TO WS-DEL-CHILD
             END-PERFORM
         END-IF

         MOVE WS-N-KEY(WS-DEL-CHILD)
             TO WS-N-KEY(WS-DEL-NODE)
         MOVE WS-DEL-CHILD TO WS-DEL-NODE

     END-PERFORM

*>    Now WS-DEL-NODE is a leaf - remove it
     IF WS-N-PARENT(WS-DEL-NODE) = 0
         MOVE 0 TO WS-ROOT
     ELSE
         MOVE WS-N-PARENT(WS-DEL-NODE)
             TO WS-DEL-PARENT
         IF WS-N-LEFT(WS-DEL-PARENT) = WS-DEL-NODE
             MOVE 0 TO WS-N-LEFT(WS-DEL-PARENT)
         ELSE
             MOVE 0 TO WS-N-RIGHT(WS-DEL-PARENT)
         END-IF
         MOVE WS-DEL-PARENT TO WS-RB-IDX
         PERFORM REBALANCE
     END-IF
     .

*>========================================================
*> REBALANCE (iterative - walks up to root)
*> Input: WS-RB-IDX
*>========================================================
 REBALANCE.
     PERFORM REBALANCE-STEP
         UNTIL WS-RB-IDX = 0
     .

 REBALANCE-STEP.
     MOVE WS-RB-IDX TO WS-SETBAL-IDX
     PERFORM SET-BALANCE

     EVALUATE TRUE

         WHEN WS-N-BAL(WS-RB-IDX) = -2
             MOVE WS-N-LEFT(WS-RB-IDX)
                 TO WS-TEMP-IDX
             MOVE WS-N-LEFT(WS-TEMP-IDX)
                 TO WS-HGT-IDX
             PERFORM GET-HEIGHT
             MOVE WS-HGT-RESULT TO WS-HEIGHT-LL
             MOVE WS-N-RIGHT(WS-TEMP-IDX)
                 TO WS-HGT-IDX
             PERFORM GET-HEIGHT
             MOVE WS-HGT-RESULT TO WS-HEIGHT-LR
             IF WS-HEIGHT-LL >= WS-HEIGHT-LR
*>                rotateRight(n)
                 MOVE WS-RB-IDX TO WS-ROT-A
                 PERFORM ROTATE-RIGHT
                 MOVE WS-ROT-RESULT TO WS-RB-IDX
             ELSE
*>                rotateLeftThenRight(n)
                 MOVE WS-N-LEFT(WS-RB-IDX)
                     TO WS-ROT-A
                 PERFORM ROTATE-LEFT
                 MOVE WS-ROT-RESULT
                     TO WS-N-LEFT(WS-RB-IDX)
                 MOVE WS-RB-IDX TO WS-ROT-A
                 PERFORM ROTATE-RIGHT
                 MOVE WS-ROT-RESULT TO WS-RB-IDX
             END-IF

         WHEN WS-N-BAL(WS-RB-IDX) = 2
             MOVE WS-N-RIGHT(WS-RB-IDX)
                 TO WS-TEMP-IDX
             MOVE WS-N-RIGHT(WS-TEMP-IDX)
                 TO WS-HGT-IDX
             PERFORM GET-HEIGHT
             MOVE WS-HGT-RESULT TO WS-HEIGHT-RR
             MOVE WS-N-LEFT(WS-TEMP-IDX)
                 TO WS-HGT-IDX
             PERFORM GET-HEIGHT
             MOVE WS-HGT-RESULT TO WS-HEIGHT-RL
             IF WS-HEIGHT-RR >= WS-HEIGHT-RL
*>                rotateLeft(n)
                 MOVE WS-RB-IDX TO WS-ROT-A
                 PERFORM ROTATE-LEFT
                 MOVE WS-ROT-RESULT TO WS-RB-IDX
             ELSE
*>                rotateRightThenLeft(n)
                 MOVE WS-N-RIGHT(WS-RB-IDX)
                     TO WS-ROT-A
                 PERFORM ROTATE-RIGHT
                 MOVE WS-ROT-RESULT
                     TO WS-N-RIGHT(WS-RB-IDX)
                 MOVE WS-RB-IDX TO WS-ROT-A
                 PERFORM ROTATE-LEFT
                 MOVE WS-ROT-RESULT TO WS-RB-IDX
             END-IF

         WHEN OTHER
             CONTINUE

     END-EVALUATE

     IF WS-N-PARENT(WS-RB-IDX) NOT = 0
         MOVE WS-N-PARENT(WS-RB-IDX) TO WS-RB-IDX
     ELSE
         MOVE WS-RB-IDX TO WS-ROOT
         MOVE 0 TO WS-RB-IDX
     END-IF
     .

*>========================================================
*> ROTATE-LEFT
*> Input:  WS-ROT-A
*> Output: WS-ROT-RESULT
*>========================================================
 ROTATE-LEFT.
*>    Node b = a.right
     MOVE WS-N-RIGHT(WS-ROT-A) TO WS-ROT-B
*>    b.parent = a.parent
     MOVE WS-N-PARENT(WS-ROT-A)
         TO WS-N-PARENT(WS-ROT-B)
*>    a.right = b.left
     MOVE WS-N-LEFT(WS-ROT-B)
         TO WS-N-RIGHT(WS-ROT-A)
*>    if (a.right != null) a.right.parent = a
     IF WS-N-RIGHT(WS-ROT-A) NOT = 0
         MOVE WS-N-RIGHT(WS-ROT-A) TO WS-TEMP-IDX
         MOVE WS-ROT-A
             TO WS-N-PARENT(WS-TEMP-IDX)
     END-IF
*>    b.left = a
     MOVE WS-ROT-A TO WS-N-LEFT(WS-ROT-B)
*>    a.parent = b
     MOVE WS-ROT-B TO WS-N-PARENT(WS-ROT-A)
*>    if (b.parent != null) { fix parent's child ptr }
     IF WS-N-PARENT(WS-ROT-B) NOT = 0
         MOVE WS-N-PARENT(WS-ROT-B) TO WS-TEMP-IDX
         IF WS-N-RIGHT(WS-TEMP-IDX) = WS-ROT-A
             MOVE WS-ROT-B
                 TO WS-N-RIGHT(WS-TEMP-IDX)
         ELSE
             MOVE WS-ROT-B
                 TO WS-N-LEFT(WS-TEMP-IDX)
         END-IF
     END-IF
*>    setBalance(a, b)
     MOVE WS-ROT-A TO WS-SETBAL-IDX
     PERFORM SET-BALANCE
     MOVE WS-ROT-B TO WS-SETBAL-IDX
     PERFORM SET-BALANCE
*>    return b
     MOVE WS-ROT-B TO WS-ROT-RESULT
     .

*>========================================================
*> ROTATE-RIGHT
*> Input:  WS-ROT-A
*> Output: WS-ROT-RESULT
*>========================================================
 ROTATE-RIGHT.
*>    Node b = a.left
     MOVE WS-N-LEFT(WS-ROT-A) TO WS-ROT-B
*>    b.parent = a.parent
     MOVE WS-N-PARENT(WS-ROT-A)
         TO WS-N-PARENT(WS-ROT-B)
*>    a.left = b.right
     MOVE WS-N-RIGHT(WS-ROT-B)
         TO WS-N-LEFT(WS-ROT-A)
*>    if (a.left != null) a.left.parent = a
     IF WS-N-LEFT(WS-ROT-A) NOT = 0
         MOVE WS-N-LEFT(WS-ROT-A) TO WS-TEMP-IDX
         MOVE WS-ROT-A
             TO WS-N-PARENT(WS-TEMP-IDX)
     END-IF
*>    b.right = a
     MOVE WS-ROT-A TO WS-N-RIGHT(WS-ROT-B)
*>    a.parent = b
     MOVE WS-ROT-B TO WS-N-PARENT(WS-ROT-A)
*>    if (b.parent != null) { fix parent's child ptr }
     IF WS-N-PARENT(WS-ROT-B) NOT = 0
         MOVE WS-N-PARENT(WS-ROT-B) TO WS-TEMP-IDX
         IF WS-N-RIGHT(WS-TEMP-IDX) = WS-ROT-A
             MOVE WS-ROT-B
                 TO WS-N-RIGHT(WS-TEMP-IDX)
         ELSE
             MOVE WS-ROT-B
                 TO WS-N-LEFT(WS-TEMP-IDX)
         END-IF
     END-IF
*>    setBalance(a, b)
     MOVE WS-ROT-A TO WS-SETBAL-IDX
     PERFORM SET-BALANCE
     MOVE WS-ROT-B TO WS-SETBAL-IDX
     PERFORM SET-BALANCE
*>    return b
     MOVE WS-ROT-B TO WS-ROT-RESULT
     .

*>========================================================
*> GET-HEIGHT
*> Input:  WS-HGT-IDX (0 = null node)
*> Output: WS-HGT-RESULT
*>========================================================
 GET-HEIGHT.
     IF WS-HGT-IDX = 0
         MOVE -1 TO WS-HGT-RESULT
     ELSE
         MOVE WS-N-HGT(WS-HGT-IDX)
             TO WS-HGT-RESULT
     END-IF
     .

*>========================================================
*> SET-BALANCE
*> Input: WS-SETBAL-IDX
*>========================================================
 SET-BALANCE.
     PERFORM REHEIGHT

     MOVE WS-N-RIGHT(WS-SETBAL-IDX) TO WS-HGT-IDX
     PERFORM GET-HEIGHT
     MOVE WS-HGT-RESULT TO WS-HGT-RIGHT

     MOVE WS-N-LEFT(WS-SETBAL-IDX) TO WS-HGT-IDX
     PERFORM GET-HEIGHT
     MOVE WS-HGT-RESULT TO WS-HGT-LEFT

     SUBTRACT WS-HGT-LEFT FROM WS-HGT-RIGHT
         GIVING WS-N-BAL(WS-SETBAL-IDX)
     .

*>========================================================
*> REHEIGHT
*> Input: WS-SETBAL-IDX
*>========================================================
 REHEIGHT.
     IF WS-SETBAL-IDX NOT = 0
         MOVE WS-N-LEFT(WS-SETBAL-IDX) TO WS-HGT-IDX
         PERFORM GET-HEIGHT
         MOVE WS-HGT-RESULT TO WS-HGT-LEFT

         MOVE WS-N-RIGHT(WS-SETBAL-IDX) TO WS-HGT-IDX
         PERFORM GET-HEIGHT
         MOVE WS-HGT-RESULT TO WS-HGT-RIGHT

         IF WS-HGT-LEFT > WS-HGT-RIGHT
             MOVE WS-HGT-LEFT TO WS-MAX-HGT
         ELSE
             MOVE WS-HGT-RIGHT TO WS-MAX-HGT
         END-IF

         ADD 1 TO WS-MAX-HGT
         MOVE WS-MAX-HGT
             TO WS-N-HGT(WS-SETBAL-IDX)
     END-IF
     .

*>========================================================
*> PRINT-BALANCE (iterative in-order traversal)
*>========================================================
 PRINT-BALANCE.
     MOVE 0 TO WS-PB-TOP
     MOVE WS-ROOT TO WS-PB-CURR

     PERFORM UNTIL WS-PB-CURR = 0
         AND WS-PB-TOP = 0

         PERFORM UNTIL WS-PB-CURR = 0
             ADD 1 TO WS-PB-TOP
             MOVE WS-PB-CURR
                 TO WS-PB-ITEMS(WS-PB-TOP)
             MOVE WS-N-LEFT(WS-PB-CURR)
                 TO WS-PB-CURR
         END-PERFORM

         IF WS-PB-TOP > 0
             MOVE WS-PB-ITEMS(WS-PB-TOP)
                 TO WS-PB-CURR
             SUBTRACT 1 FROM WS-PB-TOP
             MOVE WS-N-BAL(WS-PB-CURR)
                 TO WS-DISPLAY-BAL
             DISPLAY WS-DISPLAY-BAL " "
                 WITH NO ADVANCING
             MOVE WS-N-RIGHT(WS-PB-CURR)
                 TO WS-PB-CURR
         END-IF

     END-PERFORM
     .
