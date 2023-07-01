   square=: ^&2
   modulo1e6=: 1000000&|
   trythese=: i. 1000000                   NB. first million nonnegative integers
   which=: I.                              NB. position of true values
   which 269696=modulo1e6 square trythese  NB. right to left <-
25264 99736 150264 224736 275264 349736 400264 474736 525264 599736 650264 724736 775264 849736 900264 974736
