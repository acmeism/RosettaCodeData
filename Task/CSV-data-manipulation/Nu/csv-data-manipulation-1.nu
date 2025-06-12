open 'test_in.csv' |
  each { |row|
    let sum = ($row | values | math sum);
    $row | insert Sum $sum
  }
