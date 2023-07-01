: bullsAndCows
| numbers guess digits bulls cows |

   ListBuffer new ->numbers
   while(numbers size 4 <>) [ 9 rand dup numbers include ifFalse: [ numbers add ] else: [ drop ] ]

   while(true) [
      "Enter a number of 4 different digits between 1 and 9 : " print
      System.Console askln ->digits
      digits asInteger isNull digits size 4 <> or ifTrue: [ "Number of four digits needed" println continue ]
      digits map(#asDigit) ->guess

      guess numbers zipWith(#==) occurrences(true) ->bulls
      bulls 4 == ifTrue: [ "You won !" println return ]

      guess filter(#[numbers include]) size bulls - ->cows
      System.Out "Bulls = " << bulls << ", cows = " << cows << cr
      ] ;
