| numbers |

numbers := #(1 2 3 4 5 6 7 8).
( numbers inject: 0 into: [:sumSoFar :eachElement | sumSoFar + eachElement]) / numbers size] ) displayNl.
