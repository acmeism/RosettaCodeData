--Compound Data type can hold multiple independent values
--In Elm data can be compounded using List, Tuple, Record
--In a List
point = [2,5]
--This creates a list having x and y which are independent and can be accessed by List functions
--Note that x and y must be of same data type

--Tuple is another useful data type that stores different independent values
point = (3,4)
--Here we can have multiple data types
point1 = ("x","y")
point2 = (3,4.5)
--The order of addressing matters
--Using a Record is the best option
point = {x=3,y=4}
--To access
point.x
point.y
--Or Use it as a function
.x point
.y point
--Also to alter the value
{point | x=7}
{point | y=2}
{point | x=3,y=4}
--Each time a new record is generated
--END
