[ '710889': '7108899', 'B0YBKJ': 'B0YBKJ7', '406566': '4065663', 'B0YBLH': 'B0YBLH2',
  '228276': '2282765', 'B0YBKL': 'B0YBKL9', '557910': '5579107', 'B0YBKR': 'B0YBKR5',
  '585284': '5852842', 'B0YBKT': 'B0YBKT7', 'B00030': 'B000300'].each { text, expected ->
    println "Checking $text -> $expected"
    assert expected == text.sedol()
}
