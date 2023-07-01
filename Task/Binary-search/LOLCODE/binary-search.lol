HAI 1.2
  CAN HAS STDIO?

  VISIBLE "HAI WORLD!!!1!"
  VISIBLE "IMA GONNA SHOW U BINA POUNCE NAO"

  I HAS A list ITZ A BUKKIT
  list HAS A index0 ITZ 2
  list HAS A index1 ITZ 3
  list HAS A index2 ITZ 5
  list HAS A index3 ITZ 7
  list HAS A index4 ITZ 8
  list HAS A index5 ITZ 9
  list HAS A index6 ITZ 12
  list HAS A index7 ITZ 20

  BTW Method to access list by index number aka: list[index4]
  HOW IZ list access YR indexNameNumber
	FOUND YR list'Z SRS indexNameNumber
  IF U SAY SO

  BTW Method to print the array on the same line
  HOW IZ list printList
  I HAS A allList ITZ ""
	I HAS A indexNameNumber ITZ "index0"
	I HAS A index ITZ 0
	IM IN YR walkingLoop UPPIN YR index TIL BOTH SAEM index AN 8
		indexNameNumber R SMOOSH "index" index MKAY
		allList R SMOOSH allList " " list IZ access YR indexNameNumber MKAY MKAY
	IM OUTTA YR walkingLoop
	FOUND YR allList
  IF U SAY SO

  VISIBLE "WE START WIF BUKKIT LIEK DIS: " list IZ printList MKAY

  I HAS A target ITZ 12
  VISIBLE "AN TARGET LIEK DIS: " target

  VISIBLE "AN NAO 4 MAGI"

  HOW IZ I binaPounce YR list AN YR listLength AN YR target
	I HAS A left ITZ 0
	I HAS A right ITZ DIFF OF listLength AN 1
	IM IN YR whileLoop
		BTW exit while loop when left > right
		DIFFRINT left AN SMALLR OF left AN right
		O RLY?
			YA RLY
				GTFO
		OIC
		
		I HAS A mid ITZ QUOSHUNT OF SUM OF left AN right AN 2
		I HAS A midIndexname ITZ SMOOSH "index" mid MKAY
		
		BTW if target == list[mid] return mid
		BOTH SAEM target AN list IZ access YR midIndexname MKAY
		O RLY?
			YA RLY
				FOUND YR mid
		OIC
		
		BTW if target < list[mid] right = mid - 1
		DIFFRINT target AN BIGGR OF target AN list IZ access YR midIndexname MKAY
		O RLY?
			YA RLY
				right R DIFF OF mid AN 1
		OIC
		
		BTW if target > list[mid] left = mid + 1
		DIFFRINT target AN SMALLR OF target AN list IZ access YR midIndexname MKAY
		O RLY?
			YA RLY
				left R SUM OF mid AN 1
		OIC
	IM OUTTA YR whileLoop
	
	FOUND YR -1
  IF U SAY SO

  BTW call binary search on target here and print the index
  I HAS A targetIndex ITZ I IZ binaPounce YR list AN YR 8 AN YR target MKAY
  VISIBLE "TARGET " target " IZ IN BUKKIT " targetIndex

  VISIBLE "WE HAS TEH TARGET!!1!!"
  VISIBLE "I CAN HAS UR CHEEZBURGER NAO?"

KTHXBYE
end
