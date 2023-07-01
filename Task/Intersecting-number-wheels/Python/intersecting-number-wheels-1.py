from itertools import islice

class INW():
    """
    Intersecting Number Wheels
    represented as a dict mapping
    name to tuple of values.
    """

    def __init__(self, **wheels):
        self._wheels = wheels
        self.isect = {name: self._wstate(name, wheel)
                      for name, wheel in wheels.items()}

    def _wstate(self, name, wheel):
        "Wheel state holder"
        assert all(val in self._wheels for val in wheel if type(val) == str), \
               f"ERROR: Interconnected wheel not found in {name}: {wheel}"
        pos = 0
        ln = len(wheel)
        while True:
            nxt, pos = wheel[pos % ln], pos + 1
            yield next(self.isect[nxt]) if type(nxt) == str else nxt

    def __iter__(self):
        base_wheel_name = next(self.isect.__iter__())
        yield from self.isect[base_wheel_name]

    def __repr__(self):
        return f"{self.__class__.__name__}({self._wheels})"

    def __str__(self):
        txt = "Intersecting Number Wheel group:"
        for name, wheel in self._wheels.items():
            txt += f"\n  {name+':':4}" + ' '.join(str(v) for v in wheel)
        return txt

def first(iter, n):
    "Pretty print first few terms"
    return ' '.join(f"{nxt}" for nxt in islice(iter, n))

if __name__ == '__main__':
    for group in[
      {'A': (1, 2, 3)},
      {'A': (1, 'B', 2),
       'B': (3, 4)},
      {'A': (1, 'D', 'D'),
       'D': (6, 7, 8)},
      {'A': (1, 'B', 'C'),
       'B': (3, 4),
       'C': (5, 'B')}, # 135143145...
     ]:
        w = INW(**group)
        print(f"{w}\n  Generates:\n    {first(w, 20)} ...\n")
