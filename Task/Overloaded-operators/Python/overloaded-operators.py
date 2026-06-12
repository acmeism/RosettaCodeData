class Cuboid:
    __length: float
    __breadth: float
    __height: float

    def __init__(self):
        self.__length = 0.0
        self.__breadth = 0.0
        self.__height = 0.0

    def get_volume(self):
        return self.__length * self.__breadth * self.__height

    def set_length(self, val: float):
        self.__length = val

    def set_breadth(self, val: float):
        self.__breadth = val

    def set_height(self, val: float):
        self.__height = val

    def __add__(self, c: "Cuboid"):
        bigger_cuboid = Cuboid()

        bigger_cuboid._Cuboid__length = self.__length + c._Cuboid__length
        bigger_cuboid._Cuboid__breadth = self.__breadth + c._Cuboid__breadth
        bigger_cuboid._Cuboid__height = self.__height + c._Cuboid__height

        return bigger_cuboid

    def __sub__(self, c: "Cuboid"):
        smaller_cuboid = Cuboid()

        smaller_cuboid._Cuboid__length = self.__length - c._Cuboid__length
        smaller_cuboid._Cuboid__breadth = self.__breadth - c._Cuboid__breadth
        smaller_cuboid._Cuboid__height = self.__height - c._Cuboid__height

        return smaller_cuboid


def main():
    c1 = Cuboid()
    c2 = Cuboid()
    c3 = Cuboid()

    c1.set_length(6.0)
    c1.set_breadth(7.0)
    c1.set_height(5.0)

    c2.set_length(12.0)
    c2.set_breadth(13.0)
    c2.set_height(10.0)

    volume = c1.get_volume()

    print("Volume of 1st cuboid :", volume)

    volume = c2.get_volume()

    print("Volume of 2nd cuboid :", volume)

    c3 = c1 + c2
    volume = c3.get_volume()

    print("Volume of 3rd cuboid after adding :", volume)

    c3 = c1 - c2
    volume = c3.get_volume()

    print("Volume of 3rd cuboid after subtracting :", volume)


if __name__ == "__main__":
    main()
