['1a3c52debeffd' '2b6178c97a938stf' '3ycxdb1fgxa2yz']
| each { split chars | uniq -u }
| reduce {|a b| $a ++ $b | uniq -d }
| sort
