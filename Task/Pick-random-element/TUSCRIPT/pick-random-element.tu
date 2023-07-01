$$ MODE TUSCRIPT
list="John'Paul'George'Ringo'Peter'Paul'Mary'Obama'Putin"
sizeList=SIZE(list)
selectedNr=RANDOM_NUMBERS (1,sizeList,1)
selectedItem=SELECT(list,#selectednr)
PRINT "Selecting term ",selectedNr,"  in the list, which was ",selectedItem
