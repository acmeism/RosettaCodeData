""" Russian roulette problem """
import numpy as np

class Revolver:
    """ simulates 6-shot revolving cylinger pistol """

    def __init__(self):
        """ start unloaded """
        self.cylinder = np.array([False] * 6)

    def unload(self):
        """ empty all chambers of cylinder """
        self.cylinder[:] = False

    def load(self):
        """ load a chamber (advance til empty if full already), then advance once """
        while self.cylinder[1]:
            self.cylinder[:] = np.roll(self.cylinder, 1)
        self.cylinder[1] = True

    def spin(self):
        """ spin cylinder, randomizing position of chamber to be fired """
        self.cylinder[:] = np.roll(self.cylinder, np.random.randint(1, high=7))

    def fire(self):
        """ pull trigger of revolver, return True if fired, False if did not fire """
        shot = self.cylinder[0]
        self.cylinder[:] = np.roll(self.cylinder, 1)
        return shot

    def LSLSFSF(self):
        """ load, spin, load, spin, fire, spin, fire """
        self.unload()
        self.load()
        self.spin()
        self.load()
        self.spin()
        if self.fire():
            return True
        self.spin()
        if self.fire():
            return True
        return False

    def LSLSFF(self):
        """ load, spin, load, spin, fire, fire """
        self.unload()
        self.load()
        self.spin()
        self.load()
        self.spin()
        if self.fire():
            return True
        if self.fire():
            return True
        return False

    def LLSFSF(self):
        """ load, load, spin, fire, spin, fire """
        self.unload()
        self.load()
        self.load()
        self.spin()
        if self.fire():
            return True
        self.spin()
        if self.fire():
            return True
        return False

    def LLSFF(self):
        """ load, load, spin, fire, fire """
        self.unload()
        self.load()
        self.load()
        self.spin()
        if self.fire():
            return True
        if self.fire():
            return True
        return False


if __name__ == '__main__':

    REV = Revolver()
    TESTCOUNT = 100000
    for (name, method) in [['load, spin, load, spin, fire, spin, fire', REV.LSLSFSF],
                           ['load, spin, load, spin, fire, fire', REV.LSLSFF],
                           ['load, load, spin, fire, spin, fire', REV.LLSFSF],
                           ['load, load, spin, fire, fire', REV.LLSFF]]:

        percentage = 100 * sum([method() for _ in range(TESTCOUNT)]) / TESTCOUNT
        print("Method", name, "produces", percentage, "per cent deaths.")
