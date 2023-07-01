(import (file json))

(define o (read-json-string "
  {
    'name': 'John',
    'full name': 'John Smith',
    'age': 42,
    'weight': 156.18,
    'married': false,
    'address': {
      'street': '21 2nd Street',
      'city': 'New York',
    },
    'additional staff': [
      {
        'type': 'numbers',
        'numbers': [ 1, -2, 0.75, -4.567 ]
      },
      {
        'type': 'phone',
        'number': '222 222-2222'
      }
    ]
  }"))
(print o)

(print-json-with display o)
(print-json-with display {
  'name "John"
  '|full name| "John Smith"
  'age 42
  'married #false
  'address {
    'street "21 2nd Street"
    'city   "New York"
  }
  '|additional staff| [
    {
      'type "numbers"
      'numbers [ 1 2 3 4 ]
    }
    {
      'type "phone"
      'number "222 222-2222"
    }
  ]
