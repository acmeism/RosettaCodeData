### RING: Function Moving Average.   Bert Mariani 2016-06-22

###------------------------------
### Data array of Google prices

aGOOGPrices = ["658","675","670","664","664","663","663","662","675","693","689","675",
"636","633","632","607","607","617","617","581","593","570","574","571","575","596",
"596","601","583","635","587","574","552","531","536","502","488","482","490","503",
"507","521","534","525","534","559","552","554","555","555","552","579","580","577",
"575","562","560","559","558","569","573","577","574","559","552","553","560","569",
"582","579","593","598","593","598","593","586","602","591","594","595","603","614",
"620","625","635","627","632","631","620","626","616","606","602","659","683","671",
"670","659","673","679"]

###-------------------------------------------------------------
### CALL the Function:  MovingAverage  arrayOfPrices timePeriod

aGOOGMvgAvg = MovingAverage( aGOOGPrices, 10 )

aGOOGMvgAvg = MovingAverage( aGOOGPrices, 30 )

###-------------------------------------------------------------
### FUNCTION: MovingAverage

Func MovingAverage arrayPrices, timePeriod

    arrayMvgAvg  = []             ### Output Results to this array
    z = len(arrayPrices)          ### array data length
    sumPrices  = 0

    ###--------------------------------
    ### First MAvg Sum 1 to timePeriod
    ###--------------------------------

    for i = 1 to  timePeriod
        sumPrices = sumPrices + arrayPrices[i]
        mvgAvg    = sumPrices / i
        Add( arrayMvgAvg, mvgAvg)
    next

    ###-----------------------------------------------
    ### Second MAvg Sum  timePeriod +1 to End of Data
    ###-----------------------------------------------

    for i = timePeriod + 1 to z
        sumPrices = sumPrices - arrayPrices[i-timePeriod] + arrayPrices[i]
        mvgAvg    = sumPrices / timePeriod
        Add (arrayMvgAvg, mvgAvg
    next

return arrayMvgAvg

###-------------------------------------------------------------
OUTPUT Google Prices moving average using timePeriod = 10

Index 88 CurPrice 631 Sum 17735 MvgAvg 591.17
Index 89 CurPrice 620 Sum 17797 MvgAvg 593.23
Index 90 CurPrice 626 Sum 17854 MvgAvg 595.13
Index 91 CurPrice 616 Sum 17897 MvgAvg 596.57
Index 92 CurPrice 606 Sum 17926 MvgAvg 597.53
Index 93 CurPrice 602 Sum 17954 MvgAvg 598.47
Index 94 CurPrice 659 Sum 18054 MvgAvg 601.80
Index 95 CurPrice 683 Sum 18185 MvgAvg 606.17
Index 96 CurPrice 671 Sum 18303 MvgAvg 610.10
Index 97 CurPrice 670 Sum 18413 MvgAvg 613.77
Index 98 CurPrice 659 Sum 18503 MvgAvg 616.77
Index 99 CurPrice 673 Sum 18594 MvgAvg 619.80
Index 100 CurPrice 679 Sum 18694 MvgAvg 623.13
###-------------------------------------------------------------
