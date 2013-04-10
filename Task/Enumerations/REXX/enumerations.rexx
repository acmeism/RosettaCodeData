/*REXX program to illustrate enumeration of constants via stemmed arrays*/
fruit.=0                               /*the default for all  "FRUITS." */
fruit.apple       =   65
fruit.cherry      =    4
fruit.kiwi        =   12
fruit.peach       =   48
fruit.plum        =   50
fruit.raspberry   =   17
fruit.tomato      = 8000
fruit.ugli        =    2
fruit.watermelon  =    0.5             /*could also specify:    1/2     */

                           /*A partial list of some fruits (below).     */
                           /* [↓]   This is one method of using a list. */
FruitList='apple apricot avocado banana bilberry blackberry blackcurrent blueberry baobab boysenberry breadfruit cantalope cherry chilli chokecherry citront',
  'coconut cranberry cucumber current date dragonfruit durian eggplant elderberry fig feijoa gac gooseberry grape grapefruit guava honeydew huckleberry jackfruit',
  'jambul juneberry kiwi kumquat lemon lime lingenberry loquat lychee mandarine mango mangosteen netarine orange papaya passionfruit peach pear persimmon',
  'physalis pineapple pitaya pomegranate pomelo plum pumpkin rambutan raspberry redcurrent satsuma squash strawberry tangerine tomato ugli watermelon zucchini'
/*┌────────────────────────────────────────────────────────────────────┐
  │ Spoiler alert:  sex is discussed below: PG-13.  Most berries don't │
  │ have  "berry"  in their name.   A berry is a simple fruit produced │
  │ from a single ovary.   Some true berries are:  pomegranate, guava, │
  │ eggplant, tomato, chilli, pumpkin, cucumber, melon, and  citruses. │
  │ Blueberry  is a  false  berry,  blackberry is an  aggregate fruit, │
  │ and  strawberry  is an  accessory  fruit.    Most nuts are fruits. │
  │ The following  aren't  true nuts:    almond,  cashew,  coconut,    │
  │ macadamia,  peanut,  pecan,  pistachio,  and  walnut.              │
  └────────────────────────────────────────────────────────────────────┘*/
                        /*  [↓] due to a Central America blight in 1922.*/
if fruit.banana=0  then say "Yes!  We have no bananas today."    /*(sic)*/
if fruit.kiwi \=0  then say "We gots" fruit.kiwi  "hairy fruit." /*(sic)*/
if fruit.peach\=0  then say "We gots" fruit.peach "fuzzy fruit." /*(sic)*/
maxL = length('  fruit  ')
maxQ = length(' quantity ')
say
     do pass=1  for 2                  /*first pass finds the maximums. */
          do j=1  for words(FruitList)
          f=word(FruitList,j)          /*get a fruit name from the list.*/
          q=value('FRUIT.'f)
          if pass==1  then do          /*widest fruit name and quantity.*/
                           maxL=max(maxL,length(f)) /*longest fruit name*/
                           maxQ=max(maxQ,length(q)) /*widest fruit quant*/
                           iterate  /*j*/
                           end
          if j==1  then say center('fruit',maxL)   center('quantity',maxQ)
          if j==1  then say copies('─',maxL)       copies('─',maxQ)
          if q\=0  then say right(f,maxL)          right(q,maxQ)
          end   /*j*/
     end        /*pass*/
                                       /*stick a fork in it, we're done.*/
