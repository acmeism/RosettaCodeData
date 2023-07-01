def add(x,y) x + y end
def mul(x,y) x * y end

def sumEq(s,p) s.select{|q| add(*p) == add(*q)} end
def mulEq(s,p) s.select{|q| mul(*p) == mul(*q)} end

s1 = (a = *2...100).product(a).select{|x,y| x<y && x+y<100}
s2 = s1.select{|p| sumEq(s1,p).all?{|q| mulEq(s1,q).size != 1} }
s3 = s2.select{|p| (mulEq(s1,p) & s2).size == 1}
p    s3.select{|p| (sumEq(s1,p) & s3).size == 1}
