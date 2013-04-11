class Point(object):
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    def __repr__(self):
        return '<Point 0x%x x: %f y: %f>' % (id(self), self.x, self.y)

class Circle(Point):
    def __init__(self, x=0.0, y=0.0, radius=1.0):
        Point.__init__(self, x, y)
        self.radius = radius
    def __repr__(self):
        return '<Circle 0x%x x: %f y: %f radius: %f>' % (
            id(self), self.x, self.y, self.radius)
