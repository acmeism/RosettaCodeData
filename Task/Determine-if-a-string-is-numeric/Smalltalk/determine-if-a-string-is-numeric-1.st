String extend [
  realIsNumeric [
     (self first = $+) |
     (self first = $-)
        ifTrue: [
           ^ (self allButFirst) isNumeric
        ]
        ifFalse: [
           ^ self isNumeric
        ]
  ]
]

{ '1234'.            "true"
  '3.14'. '+3.8111'. "true"
  '+45'.             "true"
  '-3.78'.           "true"
  '-3.78.23'. "false"
  '123e3'     "false: the notation is not recognized"
} do: [ :a | a realIsNumeric printNl ]
