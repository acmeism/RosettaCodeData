yes_no = "Yes"

def yes_no.not
  replace( self=="Yes" ? "No": "Yes")
end

#Demo:
p yes_no.not # => "No"
p yes_no.not # => "Yes"
p "aaa".not  # => undefined method `not' for "aaa":String (NoMethodError)
