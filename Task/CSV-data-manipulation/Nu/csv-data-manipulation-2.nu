open 'test_in.csv' | upsert Sum {|row| $row | values | math sum }
