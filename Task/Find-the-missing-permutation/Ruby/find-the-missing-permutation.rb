given = %w{
  ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
  CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB
}

all = given[0].chars.permutation.collect(&:join)

puts "missing: #{all - given}"
