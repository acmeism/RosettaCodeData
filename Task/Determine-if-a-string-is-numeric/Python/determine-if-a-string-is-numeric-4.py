def numeric(literal):
    """Return value of numeric literal or None if can't parse a value"""
    castings = [int, float, complex,
        lambda s: int(s,2),  #binary
        lambda s: int(s,8),  #octal
        lambda s: int(s,16)] #hex
    for cast in castings:
        try:
            return cast(literal)
        except ValueError:
            pass
    return None


tests = [
    '0', '0.', '00', '123', '0123', '+123', '-123', '-123.', '-123e-4', '-.8E-04',
    '0.123', '(5)', '-123+4.5j', '0b0101', ' +0B101 ', '0o123', '-0xABC', '0x1a1',
    '12.5%', '1/2', '½', '3¼', 'π', 'Ⅻ', '1,000,000', '1 000', '- 001.20e+02',
    'NaN', 'inf', '-Infinity']

for s in tests:
    print("%14s -> %-14s %-20s is_numeric: %-5s  str.isnumeric: %s" % (
        '"'+s+'"', numeric(s), type(numeric(s)), is_numeric(s), s.isnumeric() ))
