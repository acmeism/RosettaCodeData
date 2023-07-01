[ '1223334444': '1.846439344671',
  '1223334444555555555': '1.969811065121',
  '122333': '1.459147917061',
  '1227774444': '1.846439344671',
  aaBBcccDDDD: '1.936260027482',
  '1234567890abcdefghijklmnopqrstuvwxyz': '5.169925004424',
  'Rosetta Code': '3.084962500407' ].each { s, expected ->

    println "Checking $s has a shannon entrophy of $expected"
    assert sprintf('%.12f', s.shannonEntrophy) == expected
}
