$TestStrings = @(
    'It{{em,alic}iz,erat}e{d,}, please.'
    '~/{Downloads,Pictures}/*.{jpg,gif,png}'
    '{,{,gotta have{ ,\, again\, }}more }cowbell!'
    '{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}'
    )

ForEach ( $String in $TestStrings )
    {
    ''
    $String
    '------'
    Expand-Braces $String
    }
