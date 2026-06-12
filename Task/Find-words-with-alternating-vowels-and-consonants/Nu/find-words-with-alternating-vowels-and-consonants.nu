open 'unixdict.txt'
| split words -l 10
| where $it =~ '(?i)^[AEIOU]?(?:[^AEIOU][AEIOU])*[^AEIOU]?$'
| grid -w 80
