t:0
time:100
k:-0.07
tr:20
sol:()
steps:10
h:time%steps
tn:100
while [t<time;tn1:tn + h*(k)*(tn-tr);sol:sol,tn1;tn:tn1;t:t+h]
sol
