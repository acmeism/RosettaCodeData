# Return a string space or star to print at x,y.
# Must have x<y.  x<0 is the left side of the triangle.
# If x<-y then it's before the left edge and the return is a space.
char(x,y) = (y+x>=0 && ((y+x)%2)==0 && ((y+x)&(y-x))==0 ? "*" : " ")

# Return a string which is row y of the triangle from character
# position x through to the right hand end x==y, inclusive.
row(x,y) = (x<=y ? char(x,y).row(x+1,y) : "\n")

# Return a string of stars, spaces and newlines which is the
# Sierpinski triangle from row y to limit, inclusive.
# The first row is y=0.
triangle(y,limit) = (y <= limit ? row(-limit,y).triangle(y+1,limit) : "")

# Print rows 0 to 15, which is the order 4 triangle per the task.
print triangle(0,15)
