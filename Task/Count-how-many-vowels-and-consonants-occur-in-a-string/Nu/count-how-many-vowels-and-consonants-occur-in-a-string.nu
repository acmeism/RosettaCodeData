'HOW many Vowels and Consonants occur in the String?'
| parse -r '([[:alpha:]])'
| each { $in.capture0 =~ '(?i)^[AIEOU]$' }
| uniq -c
| (sort-by value).count
| $'($in.1) vowels and ($in.0) consonants'
