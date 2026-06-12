open 'unixdict.txt' | split words | where $it =~ '(?i)^(?:[^aeiou]*e){4}[^aiou]*$'
