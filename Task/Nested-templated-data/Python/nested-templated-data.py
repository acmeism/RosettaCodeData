from pprint import pprint as pp

class Template():
    def __init__(self, structure):
        self.structure = structure
        self.used_payloads, self.missed_payloads = [], []

    def inject_payload(self, id2data):

        def _inject_payload(substruct, i2d, used, missed):
            used.extend(i2d[x] for x in substruct if type(x) is not tuple and x in i2d)
            missed.extend(f'??#{x}'
                          for x in substruct if type(x) is not tuple and x not in i2d)
            return tuple(_inject_payload(x, i2d, used, missed)
                           if type(x) is tuple
                           else i2d.get(x, f'??#{x}')
                         for x in substruct)

        ans = _inject_payload(self.structure, id2data,
                              self.used_payloads, self.missed_payloads)
        self.unused_payloads = sorted(set(id2data.values())
                                      - set(self.used_payloads))
        self.missed_payloads = sorted(set(self.missed_payloads))
        return ans

if __name__ == '__main__':
    index2data = {p: f'Payload#{p}' for p in range(7)}
    print("##PAYLOADS:\n  ", end='')
    print('\n  '.join(list(index2data.values())))
    for structure in [
     (((1, 2),
       (3, 4, 1),
       5),),

     (((1, 2),
       (10, 4, 1),
       5),)]:
        print("\n\n# TEMPLATE:")
        pp(structure, width=13)
        print("\n TEMPLATE WITH PAYLOADS:")
        t = Template(structure)
        out = t.inject_payload(index2data)
        pp(out)
        print("\n UNUSED PAYLOADS:\n  ", end='')
        unused = t.unused_payloads
        print('\n  '.join(unused) if unused else '-')
        print(" MISSING PAYLOADS:\n  ", end='')
        missed = t.missed_payloads
        print('\n  '.join(missed) if missed else '-')
