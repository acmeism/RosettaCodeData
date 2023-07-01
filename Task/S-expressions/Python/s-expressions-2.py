>>> from pprint import pprint as pp
>>> x = [[(t,v) for t,v in  termtypes.groupdict().items() if v][0] for termtypes in re.finditer(term_regex, sexp)]
>>> pp(x)
[('brackl', '('),
 ('brackl', '('),
 ('s', 'data'),
 ('sq', '"quoted data"'),
 ('num', '123'),
 ('num', '4.5'),
 ('brackr', ')'),
 ('brackl', '('),
 ('s', 'data'),
 ('brackl', '('),
 ('num', '123'),
 ('brackl', '('),
 ('num', '4.5'),
 ('brackr', ')'),
 ('sq', '"(more"'),
 ('sq', '"data)"'),
 ('brackr', ')'),
 ('brackr', ')'),
 ('brackr', ')')]
>>>
