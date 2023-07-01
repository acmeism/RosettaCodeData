import time

class Animal(object):
    def __init__(self, birth=None, alive=True):
        self.birth = birth if birth else time.time()
        self.alive = alive
    def age(self):
        return time.time() - self.birth
    def kill(self):
        self.alive = False

class Dog(Animal):
    def __init__(self, bones_collected=0, **kwargs):
        self.bone_collected = bones_collected
        super(Dog, self).__init__(**kwargs)

class Cat(Animal):
    max_lives = 9
    def __init__(self, lives=max_lives, **kwargs):
        self.lives = lives
        super(Cat, self).__init__(**kwargs)
    def kill(self):
        if self.lives>0:
            self.lives -= 1
            if self.lives == 0:
                super(Cat, self).kill()
        else:
            raise ValueError
        return self

class Labrador(Dog):
    def __init__(self, guide_dog=False, **kwargs):
        self.guide_dog=False
        super(Labrador, self).__init__(**kwargs)

class Collie(Dog):
    def __init__(self, sheep_dog=False, **kwargs):
        self.sheep_dog=False
        super(Collie, self).__init__(**kwargs)

lassie = Collie()
felix = Cat()
felix.kill().kill().kill()
mr_winkle = Dog()
buddy = Labrador()
buddy.kill()
print "Felix has",felix.lives, "lives, ","Buddy is %salive!"%("" if buddy.alive else "not ")
