local(x = array(1,2,3,4,5,6,7,8,9,10))
// sum of array elements
'Sum: '
with n in #x
sum #n
'\r'
// product of arrray elements
'Product: '
local(product = 1)
with n in #x do => { #product *= #n }
#product
