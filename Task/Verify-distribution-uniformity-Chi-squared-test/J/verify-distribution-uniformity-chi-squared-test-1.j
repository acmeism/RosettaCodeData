require 'stats/base'

countCats=: #@~.                    NB. counts the number of unique items
getExpected=: #@] % [               NB. divides no of items by category count
getObserved=: #/.~@]                NB. counts frequency for each category
calcX2=: [: +/ *:@(getObserved - getExpected) % getExpected   NB. calculates test statistic
calcDf=: <:@[                       NB. calculates degrees of freedom for uniform distribution

NB.*isUniform v Tests (5%) whether y is uniformly distributed
NB. result is: boolean describing if distribution y is uniform
NB. y is: distribution to test
NB. x is: optionally specify number of categories possible
isUniform=: (countCats $: ]) : (0.95 > calcDf chisqcdf :: 1: calcX2)
