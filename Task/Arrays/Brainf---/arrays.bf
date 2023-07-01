===========[
ARRAY DATA STRUCTURE

AUTHOR: Keith Stellyes
WRITTEN: June 2016

This is a zero-based indexing array data structure, it assumes the following
precondition:

>INDEX<|NULL|VALUE|NULL|VALUE|NULL|VALUE|NULL

(Where >< mark pointer position, and | separates addresses)

It relies heavily on [>] and [<] both of which are idioms for
finding the next left/right null

HOW INDEXING WORKS:
It runs a loop _index_ number of times, setting that many nulls
to a positive, so it can be skipped by the mentioned idioms.
Basically, it places that many "milestones".

EXAMPLE:
If we seek index 2, and our array is {1 , 2 , 3 , 4 , 5}

FINDING INDEX 2:
   (loop to find next null, set to positive, as a milestone
   decrement index)

index
  2  |0|1|0|2|0|3|0|4|0|5|0
  1  |0|1|1|2|0|3|0|4|0|5|0
  0  |0|1|1|2|1|3|0|4|0|5|0

===========]

=======UNIT TEST=======
 SET ARRAY {48 49 50}
>>++++++++++++++++++++++++++++++++++++++++++++++++>>
+++++++++++++++++++++++++++++++++++++++++++++++++>>
++++++++++++++++++++++++++++++++++++++++++++++++++
<<<<<<++ Move back to index and set it to 2
=======================

===RETRIEVE ELEMENT AT INDEX===

=ACCESS INDEX=
[>>[>]+[<]<-] loop that sets a null to a positive for each iteration
              First it moves the pointer from index to first value
               Then it uses a simple loop that finds the next null
              it sets the null to a positive (1 in this case)
               Then it uses that same loop reversed to find the first
                 null which will always be one right of our index
                 so we decrement our index
               Finally we decrement pointer from the null byte to our
              index and decrement it

>>            Move pointer to the first value otherwise we can't loop

[>]<          This will find the next right null which will always be right
              of the desired value; then go one left


.             Output the value (In the unit test this print "2"

[<[-]<]       Reset array

===ASSIGN VALUE AT INDEX===

STILL NEED TO ADJUST UNIT TESTS

NEWVALUE|>INDEX<|NULL|VALUE etc

[>>[>]+[<]<-] Like above logic except it empties the value and doesn't reset
>>[>]<[-]

[<]<          Move pointer to desired value note that where the index was stored
              is null because of the above loop
			
[->>[>]+[<]<] If NEWVALUE is GREATER than 0 then decrement it & then find the
              newly emptied cell and increment it

[>>[>]<+[<]<<-] Move pointer to first value find right null move pointer left
                then increment where we want our NEWVALUE to be stored then
                return back by finding leftmost null then decrementing pointer
                twice then decrement our NEWVALUE cell
