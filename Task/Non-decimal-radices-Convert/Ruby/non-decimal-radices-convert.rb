class String
  def convert_base(from, to)
    Integer(self, from).to_s(to)
    # self.to_i(from).to_s(to) #if you don't want exceptions
  end
end

# first three taken from TCL
p "12345".convert_base(10, 23) # => "107h"
p "107h".convert_base(23, 7) # =>"50664"
p "50664".convert_base(7, 10) # =>"12345"
p "1038334289300125869792154778345043071467300".convert_base(10, 36) # =>"zombieseatingdeadvegetables"
p "ff".convert_base(15, 10) # => ArgumentError
