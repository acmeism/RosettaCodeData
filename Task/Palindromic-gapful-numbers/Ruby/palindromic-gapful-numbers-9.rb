class PalNo
  def initialize(digit)
    @digit, @l, @dd = digit, 3, 11*digit
  end
  def fN(n)
    return [0,1,2,3,4,5,6,7,8,9] if n==1
    return [0,11,22,33,44,55,66,77,88,99] if n==2
    a=[]; [0,1,2,3,4,5,6,7,8,9].product(fN(n-2)).each{ |g0,g1| a << g0*10**(n-1)+g0+10*g1 }; return a
  end
  def show(count, keep)
    to_skip, palcnt, pals = count - keep, 0, []
    while palcnt < count
      fN(@l-2).each{ |g| pal=@digit*10**(@l-1)+@digit+10*g;
      pals << pal if pal%(@dd)==0 && (palcnt += 1) > to_skip; break if palcnt - to_skip == keep }; @l+=1
    end
    print pals; puts
  end
end

start = Time.now

(1..9).each { |digit| PalNo.new(digit).show(20, 20) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100, 15) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1000, 10) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(100_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(1_000_000, 1) }; puts "####"
(1..9).each { |digit| PalNo.new(digit).show(10_000_000, 1) }; puts "####"

puts (Time.now - start)
