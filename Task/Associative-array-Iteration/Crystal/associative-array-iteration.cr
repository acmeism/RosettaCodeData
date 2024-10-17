dict = {'A' => 1, 'B' => 2}

dict.each { |pair|
  puts pair
}

dict.each_key { |key|
  puts key
}

dict.each_value { |value|
  puts value
}
