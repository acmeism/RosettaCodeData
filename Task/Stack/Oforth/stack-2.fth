: testStack
| s |
   Stack new ->s
   s push(10)
   s push(11)
   s push(12)
   s top println
   s pop println
   s pop println
   s pop println
   s isEmpty ifTrue: [ "Stack is empty" println ] ;
