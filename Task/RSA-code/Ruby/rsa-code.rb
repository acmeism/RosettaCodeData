#!/usr/bin/ruby

require 'openssl' # for mod_exp only
require 'prime'

def rsa_encode blocks, e, n
  blocks.map{|b| b.to_bn.mod_exp(e, n).to_i}
end

def rsa_decode ciphers, d, n
  rsa_encode ciphers, d, n
end

# all numbers in blocks have to be < modulus, or information is lost
# for secure encryption only use big modulus and blocksizes
def text_to_blocks text, blocksize=64 # 1 hex = 4 bit => default is 256bit
  text.each_byte.reduce(""){|acc,b| acc << b.to_s(16).rjust(2, "0")} # convert text to hex (preserving leading 0 chars)
      .each_char.each_slice(blocksize).to_a                          # slice hexnumbers in pieces of blocksize
      .map{|a| a.join("").to_i(16)}                                  # convert each slice into internal number
end

def blocks_to_text blocks
  blocks.map{|d| d.to_s(16)}.join("")                                # join all blocks into one hex-string
        .each_char.each_slice(2).to_a                                # group into pairs
	.map{|s| s.join("").to_i(16)}                                # number from 2 hexdigits is byte
	.flatten.pack("C*")                                          # pack bytes into ruby-string
	.force_encoding(Encoding::default_external)                  # reset encoding
end

def generate_keys p1, p2
  n = p1 * p2
  t = (p1 - 1) * (p2 - 1)
  e = 2.step.each do |i|
    break i if i.gcd(t) == 1
  end
  d = 1.step.each do |i|
    break i if (i * e) % t == 1
  end
  return e, d, n
end

p1, p2 = Prime.take(100).last(2)
public_key, private_key, modulus =
  generate_keys p1, p2

print "Message: "
message = gets
blocks = text_to_blocks message, 4 # very small primes
print "Numbers: "; p blocks
encoded = rsa_encode(blocks, public_key, modulus)
print "Encrypted as: "; p encoded
decoded = rsa_decode(encoded, private_key, modulus)
print "Decrypted to: "; p decoded
final = blocks_to_text(decoded)
print "Decrypted Message: "; puts final
