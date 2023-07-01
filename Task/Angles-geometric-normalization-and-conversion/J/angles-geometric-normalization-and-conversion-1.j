   TAU =: 2p1 NB. tauday.com

   normalize =: * * 1 | | NB. signum times the fractional part of absolute value

   TurnTo=: &*

   as_turn    =:    1 TurnTo
   as_degree  =:  360 TurnTo
   as_gradian =:  400 TurnTo
   as_mil     =: 6400 TurnTo
   as_radian  =:  TAU TurnTo

   Turn    =: adverb def 'normalize as_turn inv m'
   Degree  =: adverb def 'normalize as_degree inv m'
   Gradian =: adverb def 'normalize as_gradian inv m'
   Mil     =: adverb def 'normalize as_mil inv m'
   Radian  =: adverb def 'normalize as_radian inv m'
