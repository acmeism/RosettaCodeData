{ $_ ** 3 }
   in [0..1] / 100
              exact result: 0.25
     rectangle method left: 0.245025
    rectangle method right: 0.255025
      rectangle method mid: 0.249988
composite trapezoidal rule: 0.250025
   quadratic simpsons rule: 0.25

1 / *
   in [1..100] / 1000
              exact result: 4.60517018598809
     rectangle method left: 4.65499105751468
    rectangle method right: 4.55698105751468
      rectangle method mid: 4.60476254867838
composite trapezoidal rule: 4.60598605751468
   quadratic simpsons rule: 4.60517038495714

*.self
   in [0..5000] / 5000000
              exact result: 12500000
     rectangle method left: 12499997.5
    rectangle method right: 12500002.5
      rectangle method mid: 12500000
composite trapezoidal rule: 12500000
   quadratic simpsons rule: 12500000

*.self
   in [0..6000] / 6000000
              exact result: 18000000
     rectangle method left: 17999997
    rectangle method right: 18000003
      rectangle method mid: 18000000
composite trapezoidal rule: 18000000
   quadratic simpsons rule: 18000000
