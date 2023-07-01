Hamming(n)	New count,ok,next,number,which
	For which=2,3,5 Set number=1
	For count=1:1:n Do
	. Set ok=0 Set:count<21 ok=1 Set:count=1691 ok=1 Set:count=n ok=1
	. Write:ok !,$Justify(count,5),": ",number
	. For which=2,3,5 Set next(number*which)=which
	. Set number=$Order(next(""))
	. Kill next(number)
	. Quit
	Quit
Do Hamming(2000)

    1: 1
    2: 2
    3: 3
    4: 4
    5: 5
    6: 6
    7: 8
    8: 9
    9: 10
   10: 12
   11: 15
   12: 16
   13: 18
   14: 20
   15: 24
   16: 25
   17: 27
   18: 30
   19: 32
   20: 36
 1691: 2125764000
 2000: 8062156800
