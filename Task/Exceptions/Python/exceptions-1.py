import exceptions
class SillyError(exceptions.Exception):
    def __init__(self,args=None):
         self.args=args
