class Vector:
    def __init__(self,m,value):
        self.m = m
        self.value = value
        self.angle = math.degrees(math.atan(self.m))
        self.x = self.value * math.sin(math.radians(self.angle))
        self.y = self.value * math.cos(math.radians(self.angle))

    def __add__(self,vector):
        """
        >>> Vector(1,10) + Vector(1,2)
        Vector:
            - Angular coefficient: 1.0
            - Angle: 45.0 degrees
            - Value: 12.0
            - X component: 8.49
            - Y component: 8.49
        """
        final_x = self.x + vector.x
        final_y = self.y + vector.y
        final_value = pytagoras(final_x,final_y)
        final_m = final_y / final_x
        return Vector(final_m,final_value)

    def __neg__(self):
        return Vector(self.m,-self.value)

    def __sub__(self,vector):
        return self + (- vector)

    def __mul__(self,scalar):
        """
        >>> Vector(4,5) * 2
        Vector:
            - Angular coefficient: 4
            - Angle: 75.96 degrees
            - Value: 10
            - X component: 9.7
            - Y component: 2.43

        """
        return Vector(self.m,self.value*scalar)

    def __div__(self,scalar):
        return self * (1 / scalar)

    def __repr__(self):
        """
        Returns a nicely formatted list of the properties of the Vector.

        >>> Vector(1,10)
        Vector:
            - Angular coefficient: 1
            - Angle: 45.0 degrees
            - Value: 10
            - X component: 7.07
            - Y component: 7.07

        """
        return """Vector:
    - Angular coefficient: {}
    - Angle: {} degrees
    - Value: {}
    - X component: {}
    - Y component: {}""".format(self.m.__round__(2),
               self.angle.__round__(2),
               self.value.__round__(2),
               self.x.__round__(2),
               self.y.__round__(2))
