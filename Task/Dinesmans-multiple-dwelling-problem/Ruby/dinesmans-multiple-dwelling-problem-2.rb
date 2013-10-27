#Direct positional words like top, bottom, first, second etc. can be combined; they refer to one name.
#The relative positional words higher, lower and adjacent can be combined; they need two names, not positions.

demo1 = "Abe Ben Charlie David. Abe not second top. not adjacent Ben Charlie.
David Abe adjacent. David adjacent Ben. Last line."

demo2 = "A B C D. A not adjacent D. not B adjacent higher C. C lower D. Last line"

problem1 = "Baker, Cooper, Fletcher, Miller, and Smith live on different floors of an apartment house that
contains only five floors. Baker does not live on the top floor. Cooper does not live on the bottom floor.
Fletcher does not live on either the top or the bottom floor. Miller lives on a higher floor than does Cooper.
Smith does not live on a floor adjacent to Fletcher's. Fletcher does not live on a floor adjacent to Cooper's.
Where does everyone live?"

# from the Python version:
problem2 = "Baker, Cooper, Fletcher, Miller, Guinan, and Smith
live on different floors of an apartment house that contains
only seven floors. Guinan does not live on either the top or the third or the fourth floor.
Baker does not live on the top floor. Cooper
does not live on the bottom floor. Fletcher does not live on
either the top or the bottom floor. Miller lives on a higher
floor than does Cooper. Smith does not live on a floor
adjacent to Fletcher's. Fletcher does not live on a floor
adjacent to Cooper's. Where does everyone live?"

[demo1, demo2, problem1, problem2].each{|problem| puts solve( problem ) ;puts }
