data Point = Point Integer Integer
instance Show Point where
    show (Point x y) = "Point at "++(show x)++","++(show y)

-- Constructor that sets y to 0
ponXAxis = flip Point 0

-- Constructor that sets x to 0
ponYAxis = Point 0

-- Constructor that sets x and y to 0
porigin = Point 0 0

data Circle = Circle Integer Integer Integer
instance Show Circle where
    show (Circle x y r) = "Circle at "++(show x)++","++(show y)++" with radius "++(show r)

-- Constructor that sets y to 0
conXAxis = flip Circle 0

-- Constructor that sets x to 0
conYAxis = Circle 0

-- Constructor that sets x and y to 0
catOrigin = Circle 0 0

--Constructor that sets y and r to 0
c0OnXAxis = flip (flip Circle 0) 0

--Constructor that sets x and r to 0
c0OnYAxis = flip (Circle 0) 0
