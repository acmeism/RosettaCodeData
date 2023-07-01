import re

pattern = '(.)' + '.*?' + r'\1'

def find_dup_char(subject):
    match = re.search(pattern, subject)
    if match:
        return match.groups(0)[0], match.start(0), match.end(0)

def report_dup_char(subject):
    dup = find_dup_char(subject)
    prefix = f'"{subject}" ({len(subject)})'
    if dup:
        ch, pos1, pos2 = dup
        print(f"{prefix}: '{ch}' (0x{ord(ch):02x}) duplicates at {pos1}, {pos2-1}")
    else:
        print(f"{prefix}: no duplicate characters")

show = report_dup_char
show('coccyx')
show('')
show('.')
show('abcABC')
show('XYZ ZYX')
show('1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ')
