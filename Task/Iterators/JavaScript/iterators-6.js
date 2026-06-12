> const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',]
undefined
> const colors = new LinkedList(['red', 'yellow', 'pink', 'green', 'purple', 'orange', 'blue'])
undefined
> for (const day of days) console.log(day)
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
Sunday
undefined
> for (const color of colors) console.log(color)
red
yellow
pink
green
purple
orange
blue
undefined
> nth(days, 1)
"Monday"
> nth(days, 4)
"Thursday"
> nth(days, 5)
"Friday"
> nth(colors, 1)
"red"
> nth(colors, 4)
"green"
> nth(colors, 5)
"purple"
> nthLast(days, 1)
"Sunday"
> nthLast(days, 4)
"Thursday"
> nthLast(days, 5)
"Wednesday"
> nthLast(colors, 1)
"blue"
> nthLast(colors, 4)
"green"
> nthLast(colors, 5)
"pink"
