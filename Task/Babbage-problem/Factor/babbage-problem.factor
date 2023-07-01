! Lines like this one are comments. They are meant for humans to
! read and have no effect on the instructions carried out by the
! computer (aside from Factor's parser ignoring them).

! Comments may appear after program instructions on the same
! line.

! Each word between USING: and ; is a vocabulary. By importing
! a vocabulary in this way, its words are made available for the
! program to use. This is a way to keep the space requirements
! down for deployed programs, and a nice side effect is that it
! gives readers a clue for where to look for documentation.

USING: kernel math math.ranges prettyprint sequences ;

! Before the program begins, it's incredibly helpful to have an
! understanding of Factor's dataflow model. Don't worry; it's
! not complicated, but it's confusing to read a Factor program
! without this knowledge.

! Factor is a stack-based language. What this means is that
! there is an implicit data stack in the background, waiting
! to recieve whatever manner of thing we wish to give it. Here
! is a simple arithmetic expression to demonstrate:

! language token | data stack
! ---------------+-----------
!     2            2      ! numbers place themselves on the stack.
!     1            2 1
!     4            2 1 4
!     +            2 5    ! consume 1 and 4 and leave behind 5.
!     *            10     ! consume 2 and 5 and leave behind 10.

! Thus the phrase

! 2 1 4 + *

! in Factor is a way to calculate 2 * (4 + 1).
! We could have also written this as

! 1 4 + 2 *

! with no change in meaning or outcome.

! Because of the way the data stack works, there is no need
! to specify order of operations in the language, because you do
! so inherently by the order you place things on the data stack.

! === BEGIN PROGRAM ============================================

518 99,736 2 <range>   ! Here we place three numbers on the
                       ! stack representing a range of numbers.
                       ! The first, 518, represents the starting
                       ! point of the sequence. 99,736
                       ! represents the ending point of the
                       ! sequence. 2 represents the "step" of
                       ! the sequence, or a constant distance
                       ! between members.

                       ! <range> takes those three numbers and
                       ! creates an object representing the
                       ! described range of numbers. Computers
                       ! of today are more than capable of
                       ! storing that many numbers, but <range>
                       ! doesn't store them all; it calculates
                       ! the number that is needed at the
                       ! current time.

                       ! The rationale for the sequence is as
                       ! follows. Odd squares are always odd, so
                       ! we don't need to consider them. That's
                       ! why the sequence starts with an even
                       ! number and is incremented by 2. We
                       ! choose 518 to start because it's the
                       ! largest even square less than 269,696.
                       ! We choose 99,736 to end because we
                       ! know it's a solution.

[ sq 1,000,000 mod 269,696 = ]
                       ! the [ ... ] form is called a quotation.
                       ! Think of it like a sequence that stores
                       ! code. It's a way to place code on the
                       ! data stack without executing it. This
                       ! is so that it can be used by the find
                       ! word. You could also think of it much
                       ! like a function that hasn't been given
                       ! a name.

find
                       ! When we call the find word, there are
                       ! two objects on the stack: a sequence
                       ! and a quotation. find is a word that
                       ! takes a sequence and a quotation and
                       ! applies the quotation to one member of
                       ! the sequence after another. It does
                       ! so until the quotation returns a t
                       ! value (denoting a boolean true) and
                       ! then leaves that number, along with its
                       ! index in the sequence, on the stack.

                       ! Let's take a look at what happens
                       ! for each iteration of find. Let's look
                       ! at what happens with the first number
                       ! in the sequence.

! language token | data stack
! ---------------+-----------
! 518              518               ! 518 is placed on the stack
                                     ! from the sequence by find.
! sq               268,324           ! square it
! 1,000,000        268,324 1,000,000 ! place a million on the stack
! mod              268,324           ! take modulus of 268,324
                                     ! and 1,000,000
! 269,696          268,324 269,696   ! place 269,696 on the stack
! =                f                 ! test 268,324 and 269,696 for
                                     ! equality.

                       ! So the square of the first number in
                       ! the sequence, 518, does not end with
                       ! 269,696. We'll try each number in the
                       ! sequence until we get a t.

.    ! Consume the top member of the data stack and print it out.

drop ! find leaves both the found element from the sequence
     ! and the index at which it was found on the data stack.
     ! We don't care about the index so we will call drop to
     ! remove it from the top of the data stack. All programs
     ! must end with an emtpy data stack.

! Putting the entire program together, it looks like this:

! 518 99,736 2 <range> [ sq 1,000,000 mod 269,696 = ] find . drop
