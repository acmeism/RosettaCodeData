method_names = [:==,:!=, :>, :>=, :<, :<=, :<=>, :casecmp]
[["YUP", "YUP"], ["YUP", "Yup"], ["bot","bat"],["zz", "aaa"]].each do |(str1, str2)|
  method_names.each{|m| print str1," ", m," ", str2,"\t", str1.send(m, str2),"\n"}
  puts
end
