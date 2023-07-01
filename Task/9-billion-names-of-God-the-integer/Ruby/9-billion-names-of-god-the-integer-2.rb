# Find large values of IPF
# Nigel_Galloway: May 1st., 2013.
N = 12345
@ng = []
@ipn1 = []
@ipn2 = []
def g(n,g)
  t = n-g-2
  return 1 if n<4 or t<0
  return @ng[g-2][n-4] unless n/2<g
  return @ipn1[t]
end
@ng[0] = []
(4..N).each {|q| @ng[0][q-4] = 1 + g(q-2,2)}
@ipn1[0] = @ng[0][0]
@ipn2[0] = @ng[0][N-4]
(1...(N/2-1)).each {|n|
  @ng[n] = []
  (n*2+4..N).each {|q| @ng[n][q-4] = g(q-1,n+1) + g(q-n-2,n+2)}
  @ipn1[n] = @ng[n][n*2]
  @ipn2[n] = @ng[n][N-4]
  @ng[n-1] = nil
}
@ipn2.pop if N.even?

puts "G(23) = #{@ipn1[21]}"
puts "G(123) = #{@ipn1[121]}"
puts "G(1234) = #{@ipn1[1232]}"
n = 3 + @ipn1.inject(:+) + @ipn2.inject(:+)
puts "G(12345) = #{n}"
