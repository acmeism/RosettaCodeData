enc = "9 8u18 2u1\n8 1s 6u1 b16 1s sb\n6 2 s1b4u1s sb13 3 s1\n5 3 s3 3s 11 3 s1\n4 2 s1us3u1su2s 2u4 2u3 2 s1us3u4 2u6 2u1\n4 1s 6u1sbubs2 s1b 2 s1b2 1s 6u1 b2 1susb3 2 s1b\n2 2 s1b2 3u1bs2 8 s1b4u1s s4b 3 s1\n 3 s3b 2 9 s3 3s 3 b2s 1s\n 3s 3 b1 2 s2us4 s1us2u2us1 s3 3 b1s s\nsu2s 2 4 b6u2s 1s7u1sbubs6 1bub2 1s\nbubs6 1bubs2 1b5u1bs  b7u1bs8 3 s1\n42 2u2s 1s\n41 1s3u1s s\n41 1b3u1bs\n"
def decode(str)
  str.split(/(\d+)(\D+)/).each_slice(3).map{|_,n,s| s * n.to_i}.join.tr('sub','/_\\')
end
puts decode(enc)
