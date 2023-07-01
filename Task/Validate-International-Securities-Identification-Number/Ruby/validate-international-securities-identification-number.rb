RE = /\A[A-Z]{2}[A-Z0-9]{9}[0-9]{1}\z/

def valid_isin?(str)
  return false unless str =~ RE
  luhn(str.chars.map{|c| c.to_i(36)}.join)
end

p %w(US0378331005
US0373831005
U50378331005
US03378331005
AU0000XVGZA3
AU0000VXGZA3
FR0000988040).map{|tc| valid_isin?(tc) }	

# => [true, false, false, false, true, true, true]
