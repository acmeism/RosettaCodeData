>>> import textwrap
>>> help(textwrap.fill)
Help on function fill in module textwrap:

fill(text, width=70, **kwargs)
    Fill a single paragraph of text, returning a new string.

    Reformat the single paragraph in 'text' to fit in lines of no more
    than 'width' columns, and return a new string containing the entire
    wrapped paragraph.  As with wrap(), tabs are expanded and other
    whitespace characters converted to space.  See TextWrapper class for
    available keyword args to customize wrapping behaviour.

>>> txt = '''\
Reformat the single paragraph in 'text' to fit in lines of no more
than 'width' columns, and return a new string containing the entire
wrapped paragraph.  As with wrap(), tabs are expanded and other
whitespace characters converted to space.  See TextWrapper class for
available keyword args to customize wrapping behaviour.'''
>>> print(textwrap.fill(txt, width=75))
Reformat the single paragraph in 'text' to fit in lines of no more than
'width' columns, and return a new string containing the entire wrapped
paragraph.  As with wrap(), tabs are expanded and other whitespace
characters converted to space.  See TextWrapper class for available keyword
args to customize wrapping behaviour.
>>> print(textwrap.fill(txt, width=45))
Reformat the single paragraph in 'text' to
fit in lines of no more than 'width' columns,
and return a new string containing the entire
wrapped paragraph.  As with wrap(), tabs are
expanded and other whitespace characters
converted to space.  See TextWrapper class
for available keyword args to customize
wrapping behaviour.
>>> print(textwrap.fill(txt, width=85))
Reformat the single paragraph in 'text' to fit in lines of no more than 'width'
columns, and return a new string containing the entire wrapped paragraph.  As with
wrap(), tabs are expanded and other whitespace characters converted to space.  See
TextWrapper class for available keyword args to customize wrapping behaviour.
>>>
