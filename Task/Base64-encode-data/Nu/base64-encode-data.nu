http get -r 'https://rosettacode.org/favicon.ico' | encode base64
| str replace -r '^(.{38}).*(.{37})$' '$1 ... $2'
