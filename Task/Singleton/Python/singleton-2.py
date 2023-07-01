import abc

class Singleton(object):
    """
    Singleton class implementation
    """
    __metaclass__ = abc.ABCMeta

    state = 1 #class attribute to be used as the singleton's attribute

    @abc.abstractmethod
    def __init__(self):
        pass #this prevents instantiation!

    @classmethod
    def printSelf(cls):
        print cls.state #prints out the value of the singleton's state

#demonstration
if __name__ == "__main__":
    try:
        a = Singleton() #instantiation will fail!
    except TypeError as err:
        print err
    Singleton.printSelf()
    print Singleton.state
    Singleton.state = 2
    Singleton.printSelf()
    print Singleton.state
