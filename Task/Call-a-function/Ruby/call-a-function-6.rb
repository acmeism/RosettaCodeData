def foo(a,b) a + b end

bar = foo 10,20
p bar                           #=> 30
p foo("abc","def")              #=> "abcdef"

# return multiple values
def sum_and_product(a,b) return a+b,a*b end

x,y = sum_and_product(3,5)
p x                             #=> 8
p y                             #=> 15
