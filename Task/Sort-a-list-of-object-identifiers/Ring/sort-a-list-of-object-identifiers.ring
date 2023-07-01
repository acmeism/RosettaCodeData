/*
 +--------------------------------------------------------------
 +        Program Name : SortOIDNumeric.ring
 +        Date         : 2016-07-14
 +        Author       : Bert Mariani
 +        Purpose      : Sort OID List in Numeric Order
 +--------------------------------------------------------------
*/

oldOidList =
[
	".1.3.6.1.4.1.11.2.17.19.3.4.0.10",
	".1.3.6.1.4.1.11.2.17.5.2.0.79",
	".1.3.6.1.4.1.11.2.17.19.3.4.0.4",
	".1.3.6.1.4.1.11150.3.4.0.1",
	".1.3.6.1.4.1.11.2.17.19.3.4.0.1",
	".1.3.6.1.4.1.11150.3.4.0"
]

        ### SHOW BEFORE SORT
        See nl + "oldOIDList Before Sort" +nl
        See  oldOidList

    #---------------------

     delChar = "."
     nulChar = ""
     padChar = " "
     padSize = 6
     newDotPadList = []

    ### Split list into lines
    for line in oldOidList

        ### Split line by . into components
        noDotList  = str2list( substr(line, delChar, nl) )

        ### Pad components with left blanks to make equal size
        newPadList  = PadStringList(noDotList, padChar, padSize)

        ### Join the components back to a line
        newDotPadString  = JoinStringList(delChar, newPadList)

        ### Create new list - Alpha
        Add(newDotPadList, newDotPadString)
    next

    ### Sorts Alpha list
    newDotPadListSorted = sort(newDotPadList)

         ### SHOW ALPHA INTERMEDIATE OUTPUT
         See nl + "newDotPadListSorted Intermediate Sort" +nl
         See  newDotPadListSorted

    ### Remove blanks for original look
    newOidList = RemovePadCharList( newDotPadListSorted, padChar, nulChar)

    ###--------------------

        ### SHOW AFTER SORT - NUMERIC
        See nl + "newOIDList Final Sort" +nl
        See  newOidList


###--------------------------------------------------------------------
### Function: PadStringList
###         newList = PadStringList(oldList, padChar, padSize )
###--------------------------------------------------------------------

Func PadStringList oldList, padChar, padSize
    newList = []
    for line in oldList
        newPadSize = padSize - len(line)
        newLine = Copy( padChar, newPadSize) + line
        Add(newList, newLine)
    next

    ### First line in all blank because of leading dot - remove
    Del(newList,1)
return newList

###------------------------------------------------------------
### FUNC JoinStringList
###         newString = JoinStringList( joinChar, oldList)
###------------------------------------------------------------

Func JoinStringList joinChar, OldList
    newString = ""
    for line in OldList
        newString = newString + joinChar + line
    next
return newString

###---------------------------------------------------------------------
### FUNC RemovePadCharList
###         newOidList = RemovePadCharList( oldList, padChar, nulChar)
###---------------------------------------------------------------------

Func RemovePadCharList oldList, padChar, nulChar
    newList = []
    for line in oldList
          noPadString = substr(line, padChar, nulChar)
        Add(newList, noPadString)
    next
return newList
###-----------------------------------------------------------

>;
