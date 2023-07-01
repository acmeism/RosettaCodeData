toFrac=: '/r' 0&".@charsub ]                           NB. read fractions from string
fractran15=: ({~ (= <.) i. 1:)@(toFrac@[ * ]) ^:(<15)  NB. return first 15 Fractran results
