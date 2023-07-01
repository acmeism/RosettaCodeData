epoch=$(( $(date -j -f '%B %d %Y %l:%M%p %Z' 'March 7 2009 7:30pm EST' +%s) + 43200 ))
date -r $epoch
TZ=Australia/Perth date -r $epoch
