P=: (#~ 'B' ~: {:"1) P         NB. Baker not on top floor
P=: (#~ 'C' ~: {."1) P         NB. Cooper not on bottom floor
P=: (#~ 'F' ~: {:"1) P         NB. Fletcher not on top floor
P=: (#~ 'F' ~: {."1) P         NB. Fletcher not on bottom floor
P=: (#~ </@i."1&'CM') P        NB. Miller on higher floor than Cooper
P=: (#~ 0 = +/@E."1~&'SF') P   NB. Smith not immediately below Fletcher
P=: (#~ 0 = +/@E."1~&'FS') P   NB. Fletcher not immediately below Smith
P=: (#~ 0 = +/@E."1~&'CF') P   NB. Cooper not immediately below Fletcher
P=: (#~ 0 = +/@E."1~&'FC') P   NB. Fletcher not immediately below Cooper
