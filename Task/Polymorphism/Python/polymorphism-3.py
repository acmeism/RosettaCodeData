>>> from collections import namedtuple
>>> class Point(namedtuple('Point', 'x y')):
	def __new__( _cls, x=0, y=0 ):
		return super().__new__(_cls, x, y)

	
>>> class Circle(namedtuple('Circle', 'x y r')):
	def __new__( _cls, x=0, y=0, r=0 ):
		return super().__new__(_cls, x, y, r)

	
>>> Point(), Point(x=1), Point(y=2), Point(3, 4)
(Point(x=0, y=0), Point(x=1, y=0), Point(x=0, y=2), Point(x=3, y=4))
>>> Circle(), Circle(r=2), Circle(1, 2, 3)
(Circle(x=0, y=0, r=0), Circle(x=0, y=0, r=2), Circle(x=1, y=2, r=3))
>>> p = Point(1.25, 3.87)
>>> p
Point(x=1.25, y=3.87)
>>> p.x = 10.81
Traceback (most recent call last):
  File "<pyshell#27>", line 1, in <module>
    p.x = 10.81
AttributeError: can't set attribute
>>>
