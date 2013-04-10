class BaseQueue(object):
    """Abstract/Virtual Class
    """
    def __init__(self):
        self.contents = list()
        raise NotImplementedError
    def Enqueue(self, item):
        raise NotImplementedError
    def Dequeue(self):
        raise NotImplementedError
    def Print_Contents(self):
        for i in self.contents:
            print i,
