// make global variables with :: because while is only locally scoped
tn1::100
tn::100
// to store solution
sol::()
// these are constant, so only local scope
k:-0.07
time:100
steps:10
h:time%steps
tr:20
// applying x+h to 0 outside to end while loop
// bind to a variable to surpress output
var: {x<100}{tn1::tn+h*k*(tn-tr);sol::sol,tn;tn::tn1;x+h}\0
sol
