import re

txt = """
Hi there, how are you today? I'd like to present to you the washing machine 9001.
You have been nominated to win one of these! Just make sure you don't break it"""

def haspunctotype(s):
    return 'S' if '.' in s else 'E' if '!' in s else 'Q' if '?' in s else 'N'

txt = re.sub('\n', '', txt)
pars = [s.strip() for s in re.split("(?:(?:(?<=[\?\!\.])(?:))|(?:(?:)(?=[\?\!\.])))", txt)]
if len(pars) % 2:
    pars.append('')  # if ends without punctuation
for i in range(0, len(pars)-1, 2):
    print((pars[i] + pars[i + 1]).ljust(54), "==>", haspunctotype(pars[i + 1]))
