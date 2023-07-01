def juggler(k) = k.even? ? Integer.sqrt(k) : Integer.sqrt(k*k*k)

(20..39).chain([113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443, 275485, 1267909, 2264915]).each do |k|
  k1 = k
  l = h = i = 0
  until k == 1 do
    h, i = k, l if k > h
    l += 1
    k =  juggler(k)
  end
  if k1 < 40 then
    puts "#{k1}: l[n] = #{l}, h[n] = #{h}, i[n] = #{i}"
  else
    puts "#{k1}: l[n] = #{l}, d[n] = #{h.to_s.size}, i[n] = #{i}"
  end
end
