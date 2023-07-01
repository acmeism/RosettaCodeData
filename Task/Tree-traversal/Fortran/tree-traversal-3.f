      MODULE ARAUCARIA	!Cunning crosswords, also.
       INTEGER ENUFF		!To suit the set example.
       PARAMETER (ENUFF = 9)	!This will do.
       INTEGER NODE(ENUFF),LINKL(ENUFF),LINKR(ENUFF)	!The nodes, and their links.
       DATA NODE/ 1,2,3,4,5,6,7,8,9/	!Value = index. A rather boring payload.
       DATA LINKL/2,4,6,7,0,8,0,0,0/	!"Left" and "Right" are as looking at the page.
       DATA LINKR/3,5,0,0,0,9,0,0,0/	!If one thinks within the tree, they're the other way around!
C              1	!Thus, looking from the "1", to the right is "2" and to the left is "3".
C             / \	!But, looking at the scheme, to the left is "2" and to the right is "3".
C            /   \	!This latter seems to be the popular view from the outside, not within the data.
C           /     \	!Similarily, although called a "tree", the depiction is upside down!
C          2       3	!How can computers be expected to keep up with this contrariness?
C         / \     /	!Humm, no example of a rightwards link with no leftwards link.
C        4   5   6	!Topologically equivalent, but not so in usage.
C       /       / \
C      7       8   9
       INTEGER N,LIST(ENUFF)	!This is to be developed.
       INTEGER LEVEL,MAXLEVEL	!While these vary in various ways.
       INTEGER GASP		!Communication from JANE.
       CONTAINS	!No checks for invalid links, etc.
        SUBROUTINE OUT(IS)	!Append a value to a list.
         INTEGER IS		!The value.
          N = N + 1		!The list's count so far.
          LIST(N) = IS		!Place.
        END SUBROUTINE OUT	!Eventually, the list can be written in one go.

        RECURSIVE SUBROUTINE TARZAN(HAS,STYLE)	!Skilled at tree traversal, is he.
         INTEGER HAS		!The current position.
         CHARACTER*(*) STYLE	!Traversal type.
          LEVEL = LEVEL + 1	!A leap is made.
          IF (LEVEL.GT.MAXLEVEL) MAXLEVEL = LEVEL	!Staring at the moon.
          SELECT CASE(STYLE)	!And, in what manner?
           CASE ("PRE")		!Declare the position first.
            CALL OUT(HAS)	!Thus.
            IF (LINKL(HAS).GT.0) CALL TARZAN(LINKL(HAS),STYLE)
            IF (LINKR(HAS).GT.0) CALL TARZAN(LINKR(HAS),STYLE)
           CASE ("IN")		!Or in the middle.
            IF (LINKL(HAS).GT.0) CALL TARZAN(LINKL(HAS),STYLE)
            CALL OUT(HAS)	!Thus.
            IF (LINKR(HAS).GT.0) CALL TARZAN(LINKR(HAS),STYLE)
           CASE ("POST")	!Or at the end.
            IF (LINKL(HAS).GT.0) CALL TARZAN(LINKL(HAS),STYLE)
            IF (LINKR(HAS).GT.0) CALL TARZAN(LINKR(HAS),STYLE)
            CALL OUT(HAS)	!Thus.
           CASE ("LEVEL")	!Or at specified levels.
            IF (LEVEL.EQ.GASP) CALL OUT(HAS)	!Such as this?
            IF (LINKL(HAS).GT.0) CALL TARZAN(LINKL(HAS),STYLE)
            IF (LINKR(HAS).GT.0) CALL TARZAN(LINKR(HAS),STYLE)
           CASE DEFAULT		!This shouldn't happen.
            WRITE (6,*) "Unknown style ",STYLE	!But, paranoia.
            STOP "No can do!"		!Rather than flounder about.
          END SELECT		!That was simple.
          LEVEL = LEVEL - 1	!Sag back.
        END SUBROUTINE TARZAN	!Not like George of the Jungle.

        SUBROUTINE JANE(HOW)	!Tells Tarzan what to do.
         CHARACTER*(*) HOW	!A single word suffices.
          N = 0			!No positions trampled.
          LEVEL = 0		!Starting on the ground.
          MAXLEVEL = 0		!The ascent follows.
          IF (HOW.NE."LEVEL") THEN	!Ordinary styles?
            CALL TARZAN(1,HOW)		!Yes. From the root, go...
           ELSE			!But this is not tree-structured.
            GASP = 0		!Instead, we ascend through the canopy in stages.
    1       GASP = GASP + 1		!Up one stage.
            CALL TARZAN(1,HOW)		!And do it all again.
            IF (GASP.LT.MAXLEVEL) GO TO 1	!Are we there yet?
          END IF		!Don't know MAXLEVEL until after the first clamber.
Cast forth the list.
          WRITE (6,10) HOW,NODE(LIST(1:N))	!Show spoor.
   10     FORMAT (A6,"-order:",66(1X,I0))	!Large enough.
          WRITE (6,*)				!Sigh.
        END SUBROUTINE JANE	!That was simple.
      END MODULE ARAUCARIA	!The monkeys are puzzled.

      PROGRAM GORILLA		!No fancy stuff. Just brute force.
      USE ARAUCARIA		!This is for lightweight but cunning monkeys.
      INTEGER IT		!A finger.
      INTEGER SP,STACK(ENUFF)	!The tree may be slim.
      INTEGER SLEVL(ENUFF)	!So prepare for maximum usage.
      INTEGER MIST(ENUFF,0:ENUFF)	!Multiple lists.

Chase the links preorder style: name the node, delve its left link, delve its right link.
      N = 0	!No nodes have been visited.
      SP = 0	!My stack is empty.
      IT = 1	!I start at the root.
   10 N = N + 1			!Another node arrived at.
      LIST(N) = IT		!Finger it.
      IF (LINKL(IT).GT.0) THEN	!A left link?
        IF (LINKR(IT).GT.0) THEN	!Yes. A right link also?
          SP = SP + 1				!Yes. Stack it up.
          STACK(SP) = LINKR(IT)			!For later investigation.
        END IF				!So much for the right link.
        IT = LINKL(IT)			!Fingered by the left link.
        GO TO 10			!See what happens.
      END IF			!But if there is no left link,
      IF (LINKR(IT).GT.0) THEN	!There still might be a right link.
        IT = LINKR(IT)			!There is.
        GO TO 10			!See what happens.
      END IF			!And if there are no links,
      IF (SP.GT.0) THEN		!Perhaps the stack has bottomed out too?
        IT = STACK(SP)			!No, this was deferred.
        SP = SP - 1			!So, pick up where we left off.
        GO TO 10			!And carry on.
      END IF			!So much for unstacking.
      WRITE (6,12) "Preorder",NODE(LIST(1:N))	!I've got a little list!
   12 FORMAT (A12,":",66(1X,I0))
      CALL JANE("PRE")		!Try it fancy style.

Chase the links inorder style: delve left fully, name the node and try its right, then unstack.
      N = 0	!No nodes have been visited.
      SP = 0	!My stack is empty.
      IT = 1	!I start at the root.
   20 SP = SP + 1		!I'm on the way down.
      STACK(SP) = IT		!So, save this position to later retreat to.
      IF (LINKL(IT).GT.0) THEN	!Can I delve further left?
        IT = LINKL(IT)			!Yes.
        GO TO 20			!And see what happens.
      END IF			!So much for diving.
   21 IF (SP.GT.0) THEN	!Can I retreat?
        IT = STACK(SP)		!Yes.
        SP = SP - 1		!Go back to whence I had delved left.
        N = N + 1		!This now counts as a place in order.
        LIST(N) = IT		!So list it.
        IF (LINKR(IT).GT.0) THEN!Have I a rightwards path?
          IT = LINKR(IT)		!Yes. Take it.
          GO TO 20			!And delve therefrom.
        END IF			!This node is now finished with.
        GO TO 21		!So, try for another retreat.
      END IF		!So much for unstacking.
      WRITE (6,12) "Inorder",NODE(LIST(1:N))	!I've got a little list!
      CALL JANE("IN")	!Try with more style.

Chase the links postorder style: delve left fully, delve right, name the node, then unstack.
      N = 0	!No nodes have been visited.
      SP = 0	!My stack is empty.
      IT = 1	!I start at the root.
   30 SP = SP + 1	!Action follows delving,
      STACK(SP) = IT	!So this node will be returned to.
      IF (LINKL(IT).GT.0) THEN	!Take any leftwards link straightaway.
        IT = LINKL(IT)		!Thus.
        GO TO 30		!Thanks to the stack, we'll return to IT (as was).
      END IF		!But if there is no leftwards link to follow,
      IF (LINKR(IT).GT.0) THEN	!Perhaps there is a rightwards one?
        STACK(SP) = -STACK(SP)	!=-IT Mark the stacked finger as a rightwards lurch!
        IT = LINKR(IT)		!The rightwards link is now to be taken.
        GO TO 30		!Thus start on a sub-tree.
      END IF		!But if there is no rightwards link either,
  31  IF (SP.GT.0) THEN	!See if there is anywhere to retreat to.
        IT = STACK(SP)		!The same IT placed at 30 if we dropped into 31.
        SP = SP - 1		!But now we're in a different mood.
        IF (IT.LT.0) THEN	!Returning to what had been a rightwards departure?
          N = N + 1			!Yes! Then this node is post-interest.
          LIST(N) = -IT			!So, time to roll it forth at last.
          GO TO 31			!And retreat some more.
        END IF			!But if we hadn't gone right from IT,
        IF (LINKR(IT).LE.0) THEN!We had gone left.
          N = N + 1			!And now there is nowhere rightwards.
          LIST(N) = IT			!So this node is post-interest.
          GO TO 31			!And retreat some more.
        END IF			!But if there is a rightwards leap,
        SP = SP + 1			!Prepare to return to it,
        STACK(SP) = -IT			!Marked as having gone rightwards.
        IT = LINKR(IT)			!The rightwards move.
        GO TO 30			!Peruse a fresh sub-tree.
      END IF			!And if the stack is reduced,
      WRITE (6,12) "Postorder",NODE(LIST(1:N))	!Results!
      CALL JANE("POST")		!The same again?

Chase the nodes level style.
      SP = 0		!My stack is empty.
      IT = 1		!I start at the root.
      LEVEL = 0		!On the ground.
      MAXLEVEL = 0	!No ascent as yet.
      MIST(:,0) = 0	!At all levels, nothing.
   40 LEVEL = LEVEL + 1			!Every arrival is one level up.
      IF (LEVEL.GT.MAXLEVEL) MAXLEVEL = LEVEL	!Note the most high.
      MIST(LEVEL,0) = MIST(LEVEL,0) + 1	!The count at that level.
      MIST(LEVEL,MIST(LEVEL,0)) = IT	!Add to the level's list.
      IF (LINKL(IT).GT.0) THEN		!Righto, can we go left?
        IF (LINKR(IT).GT.0) THEN	!Yes. Rightwards as well?
          SP = SP + 1				!Yes! This will have to wait.
          STACK(SP) = LINKR(IT)			!So remember it,
          SLEVL(SP) = LEVEL			!And what level we're at now.
        END IF				!I can only go one way at a time.
        IT = LINKL(IT)			!Accept the fingered leftwards lurch.
        GO TO 40			!Go to IT.
      END IF			!But if there is no leftwards link,
      IF (LINKR(IT).GT.0) THEN	!Perhaps there is a rightwards one?
        IT = LINKR(IT)			!There is.
        GO TO 40			!Go to IT.
      END IF			!And if there are no further links,
      IF (SP.GT.0) THEN		!Perhaps we can retreat to what was deferred.
        IT = STACK(SP)			!The finger.
        LEVEL = SLEVL(SP)		!The level.
        SP = SP - 1			!Wind back the stack.
        GO TO 40			!Go to IT.
      END IF			!So much for the stack.
      WRITE (6,12) "Levelorder",	!Roll the lists in ascending LEVEL order.
     1 (NODE(MIST(LEVEL,1:MIST(LEVEL,0))), LEVEL = 1,MAXLEVEL)
      CALL JANE("LEVEL")	!Alternatively...
      END	!So much for that.
