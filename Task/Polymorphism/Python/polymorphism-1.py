class Point(object):
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    def __repr__(self):
        return '<Point 0x%x x: %f y: %f>' % (id(self), self.x, self.y)

class Circle(object):
    def __init__(self, center=None, radius=1.0):
        self.center = center or Point()
        self.radius = radius
    def __repr__(self):
        return '<Circle 0x%x x: %f y: %f radius: %f>' % (
            id(self), self.center.x, self.center.y, self.radius)
