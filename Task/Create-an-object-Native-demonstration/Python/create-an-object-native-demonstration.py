from collections import UserDict
import copy

class Dict(UserDict):
    '''
    >>> d = Dict(a=1, b=2)
    >>> d
    Dict({'a': 1, 'b': 2})
    >>> d['a'] = 55; d['b'] = 66
    >>> d
    Dict({'a': 55, 'b': 66})
    >>> d.clear()
    >>> d
    Dict({'a': 1, 'b': 2})
    >>> d['a'] = 55; d['b'] = 66
    >>> d['a']
    55
    >>> del d['a']
    >>> d
    Dict({'a': 1, 'b': 66})
    '''
    def __init__(self, dict=None, **kwargs):
        self.__init = True
        super().__init__(dict, **kwargs)
        self.default = copy.deepcopy(self.data)
        self.__init = False

    def __delitem__(self, key):
        if key in self.default:
            self.data[key] = self.default[key]
        else:
            raise NotImplementedError

    def __setitem__(self, key, item):
        if self.__init:
            super().__setitem__(key, item)
        elif key in self.data:
            self.data[key] = item
        else:
            raise KeyError

    def __repr__(self):
        return "%s(%s)" % (type(self).__name__, super().__repr__())

    def fromkeys(cls, iterable, value=None):
        if self.__init:
            super().fromkeys(cls, iterable, value)
        else:
            for key in iterable:
                if key in self.data:
                    self.data[key] = value
                else:
                    raise KeyError

    def clear(self):
        self.data.update(copy.deepcopy(self.default))

    def pop(self, key, default=None):
        raise NotImplementedError

    def popitem(self):
        raise NotImplementedError

    def update(self, E, **F):
        if self.__init:
            super().update(E, **F)
        else:
            haskeys = False
            try:
                keys = E.keys()
                haskeys = Ture
            except AttributeError:
                pass
            if haskeys:
                for key in keys:
                    self[key] = E[key]
            else:
                for key, val in E:
                    self[key] = val
            for key in F:
                self[key] = F[key]

    def setdefault(self, key, default=None):
        if key not in self.data:
            raise KeyError
        else:
            return super().setdefault(key, default)
