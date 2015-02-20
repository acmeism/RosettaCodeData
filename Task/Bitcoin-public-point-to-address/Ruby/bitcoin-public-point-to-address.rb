#  Translate public point to Bitcoin address
#
#  Nigel_Galloway
#  October 12th., 2014
require 'digest/sha2'
def convert g
  i,e = '',[]
  (0...g.length/2).each{|n| e[n] = g[n+=n]+g[n+1]; i+='H2'}
  e.pack(i)
end
X = '50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352'
Y = '2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'
n = '00'+Digest::RMD160.hexdigest(Digest::SHA256.digest(convert('04'+X+Y)))
n+= Digest::SHA256.hexdigest(Digest::SHA256.digest(convert(n)))[0,8]
G = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
n,res = n.hex,''
while n > 0 do
  n,ng = n.divmod(58)
  res << G[ng]
end
puts res.reverse
