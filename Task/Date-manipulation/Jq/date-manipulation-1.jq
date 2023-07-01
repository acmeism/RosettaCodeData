"March 7 2009 7:30pm EST"
| strptime("%B %d %Y %I:%M%p %Z")
| .[3] += 12
| mktime | strftime("%B %d %Y %I:%M%p %Z")
