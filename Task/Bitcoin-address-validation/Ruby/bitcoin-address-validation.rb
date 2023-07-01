#  Validate Bitcoin address
#
#  Nigel_Galloway
#  October 13th., 2014
require 'digest/sha2'
def convert g
  i,e = '',[]
  (0...g.length/2).each{|n| e[n] = g[n+=n]+g[n+1]; i+='H2'}
  e.pack(i)
end
N = [0,1,2,3,4,5,6,7,8,nil,nil,nil,nil,nil,nil,nil,9,10,11,12,13,14,15,16,nil,17,18,19,20,21,nil,22,23,24,25,26,27,28,29,30,31,32,nil,nil,nil,nil,nil,nil,33,34,35,36,37,38,39,40,41,42,43,nil,44,45,46,47,48,49,50,51,52,53,54,55,56,57]
A = '1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62x'
g = A.bytes.inject(0){|g,n| g*58+N[n-49]}.to_s(16) # A small and interesting piece of code to do the decoding of base58-encoded data.
n = g.slice!(0..-9)
(n.length...42).each{n.insert(0,'0')}
puts "I think the checksum should be #{g}\nI calculate that it is         #{Digest::SHA256.hexdigest(Digest::SHA256.digest(convert(n)))[0,8]}"
