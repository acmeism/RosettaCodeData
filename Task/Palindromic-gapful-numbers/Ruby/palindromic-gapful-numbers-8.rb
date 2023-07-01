class PalNo
  def initialize(set)
    @set, @l=set, 3
  end
  def fN(n)
    return [0,1,2,3,4,5,6,7,8,9] if n==1
    return [0,11,22,33,44,55,66,77,88,99] if n==2
    a=[]; [0,1,2,3,4,5,6,7,8,9].product(fN(n-2)).each{|g| a.push(g[0]*10**(n-1)+g[0]+10*g[1])}; return a
  end
  def each
    while true do fN(@l-2).each{|g| a=@set*10**(@l-1)+@set+10*g; yield a if a%(11*@set)==0}; @l+=1 end
  end
end

for n in 1..9 do palNo=PalNo.new(n); g=1; palNo.each{|n| print "#{n} "; g+=1; break unless g<21}; puts "" end; puts "####"
for n in 1..9 do palNo=PalNo.new(n); g=1; palNo.each{|n| print "#{n} " if g>85; g+=1; break unless g<101}; puts "" end; puts "####"
for n in 1..9 do palNo=PalNo.new(n); g=1; palNo.each{|n| print "#{n} " if g>990; g+=1; break unless g<1001}; puts "" end; puts "####"
