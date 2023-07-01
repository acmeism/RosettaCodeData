import datetime
today = datetime.date.today()
# The first requested format is a method of datetime objects:
today.isoformat()
# For full flexibility, use the strftime formatting codes from the link above:
today.strftime("%A, %B %d, %Y")
# This mechanism is integrated into the general string formatting system.
# You can do this with positional arguments referenced by number
"The date is {0:%A, %B %d, %Y}".format(d)
# Or keyword arguments referenced by name
"The date is {date:%A, %B %d, %Y}".format(date=d)
# Since Python 3.6, f-strings allow the value to be inserted inline
f"The date is {d:%A, %B %d, %Y}"
