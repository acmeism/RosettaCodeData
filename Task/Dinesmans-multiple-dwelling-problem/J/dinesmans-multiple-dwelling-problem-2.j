possible=: (#~ 'B' ~: {:"1) possible         NB. Baker not on top floor
possible=: (#~ 'C' ~: {."1) possible         NB. Cooper not on bottom floor
possible=: (#~ 'F' ~: {:"1) possible         NB. Fletcher not on top floor
possible=: (#~ 'F' ~: {."1) possible         NB. Fletcher not on bottom floor
possible=: (#~ </@i."1&'CM') possible        NB. Miller on higher floor than Cooper
possible=: (#~ 0 = +/@E."1~&'SF') possible   NB. Smith not immediately below Fletcher
possible=: (#~ 0 = +/@E."1~&'FS') possible   NB. Fletcher not immediately below Smith
possible=: (#~ 0 = +/@E."1~&'CF') possible   NB. Cooper not immediately below Fletcher
possible=: (#~ 0 = +/@E."1~&'FC') possible   NB. Fletcher not immediately below Cooper
