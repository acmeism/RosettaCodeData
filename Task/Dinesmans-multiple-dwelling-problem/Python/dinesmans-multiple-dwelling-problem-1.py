import re
from itertools import product

problem_re = re.compile(r"""(?msx)(?:

# Multiple names of form n1, n2, n3, ... , and nK
(?P<namelist> [a-zA-Z]+ (?: , \s+ [a-zA-Z]+)* (?: ,? \s+ and) \s+ [a-zA-Z]+ )

# Flexible floor count (2 to 10 floors)
| (?:  .* house \s+ that \s+ contains \s+ only \s+
  (?P<floorcount> two|three|four|five|six|seven|eight|nine|ten ) \s+ floors \s* \.)

# Constraint: "does not live on the n'th floor"
|(?: (?P<not_live>  \b [a-zA-Z]+ \s+ does \s+ not \s+ live \s+ on \s+ the \s+
  (?: top|bottom|first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth) \s+ floor \s* \. ))

# Constraint: "does not live on either the I'th or the J'th [ or the K'th ...] floor
|(?P<not_either> \b [a-zA-Z]+ \s+ does \s+ not \s+ live \s+ on \s+ either
  (?: \s+ (?: or \s+)? the \s+
    (?: top|bottom|first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth))+ \s+ floor \s* \. )

# Constraint: "P1 lives on a higher/lower floor than P2 does"
|(?P<hi_lower> \b  [a-zA-Z]+ \s+ lives \s+ on \s+ a \s (?: higher|lower)
   \s+ floor \s+ than (?: \s+ does)  \s+  [a-zA-Z]+ \s* \. )

# Constraint: "P1 does/does not live on a floor adjacent to P2's"
|(?P<adjacency>  \b [a-zA-Z]+ \s+ does (?:\s+ not)? \s+ live \s+ on \s+ a \s+
   floor \s+ adjacent \s+ to \s+  [a-zA-Z]+ (?: 's )? \s* \. )

# Ask for the solution
|(?P<question> Where \s+ does \s+ everyone \s+ live \s* \?)

)
""")

names, lennames = None, None
floors = None
constraint_expr = 'len(set(alloc)) == lennames' # Start with all people on different floors

def do_namelist(txt):
    " E.g. 'Baker, Cooper, Fletcher, Miller, and Smith'"
    global names, lennames
    names = txt.replace(' and ', ' ').split(', ')
    lennames = len(names)

def do_floorcount(txt):
    " E.g. 'five'"
    global floors
    floors = '||two|three|four|five|six|seven|eight|nine|ten'.split('|').index(txt)

def do_not_live(txt):
    " E.g. 'Baker does not live on the top floor.'"
    global constraint_expr
    t = txt.strip().split()
    who, floor = t[0], t[-2]
    w, f = (names.index(who),
            ('|first|second|third|fourth|fifth|sixth|' +
             'seventh|eighth|ninth|tenth|top|bottom|').split('|').index(floor)
            )
    if f == 11: f = floors
    if f == 12: f = 1
    constraint_expr += ' and alloc[%i] != %i' % (w, f)

def do_not_either(txt):
    " E.g. 'Fletcher does not live on either the top or the bottom floor.'"
    global constraint_expr
    t = txt.replace(' or ', ' ').replace(' the ', ' ').strip().split()
    who, floor = t[0], t[6:-1]
    w, fl = (names.index(who),
             [('|first|second|third|fourth|fifth|sixth|' +
               'seventh|eighth|ninth|tenth|top|bottom|').split('|').index(f)
              for f in floor]
             )
    for f in fl:
        if f == 11: f = floors
        if f == 12: f = 1
        constraint_expr += ' and alloc[%i] != %i' % (w, f)


def do_hi_lower(txt):
    " E.g. 'Miller lives on a higher floor than does Cooper.'"
    global constraint_expr
    t = txt.replace('.', '').strip().split()
    name_indices = [names.index(who) for who in (t[0], t[-1])]
    if 'lower' in t:
        name_indices = name_indices[::-1]
    constraint_expr += ' and alloc[%i] > alloc[%i]' % tuple(name_indices)

def do_adjacency(txt):
    ''' E.g. "Smith does not live on a floor adjacent to Fletcher's."'''
    global constraint_expr
    t = txt.replace('.', '').replace("'s", '').strip().split()
    name_indices = [names.index(who) for who in (t[0], t[-1])]
    constraint_expr += ' and abs(alloc[%i] - alloc[%i]) > 1' % tuple(name_indices)

def do_question(txt):
    global constraint_expr, names, lennames

    exec_txt = '''
for alloc in product(range(1,floors+1), repeat=len(names)):
    if %s:
        break
else:
    alloc = None
''' % constraint_expr
    exec(exec_txt, globals(), locals())
    a = locals()['alloc']
    if a:
        output= ['Floors are numbered from 1 to %i inclusive.' % floors]
        for a2n in zip(a, names):
            output += ['  Floor %i is occupied by %s' % a2n]
        output.sort(reverse=True)
        print('\n'.join(output))
    else:
        print('No solution found.')
    print()

handler = {
    'namelist': do_namelist,
    'floorcount': do_floorcount,
    'not_live': do_not_live,
    'not_either': do_not_either,
    'hi_lower': do_hi_lower,
    'adjacency': do_adjacency,
    'question': do_question,
    }
def parse_and_solve(problem):
    p = re.sub(r'\s+', ' ', problem).strip()
    for x in problem_re.finditer(p):
        groupname, txt = [(k,v) for k,v in x.groupdict().items() if v][0]
        #print ("%r, %r" % (groupname, txt))
        handler[groupname](txt)
