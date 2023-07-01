'names numbers'=:|:;:;._2]0 :0
beef      3.8  36
pork      5.4  43
ham       3.6  90
greaves   2.4  45
flitch    4.0  30
brawn     2.5  56
welt      3.7  67
salami    3.0  95
sausage   5.9  98
)
'weights prices'=:|:".numbers
order=: \:prices%weights
take=: 15&<.&.(+/\) order{weights
result=: (*take)#(order{names),.' ',.":,.take
