Python 3.2.3 (default, May  3 2012, 15:54:42)
[GCC 4.6.3] on linux2
Type "copyright", "credits" or "license()" for more information.
>>> help('pprint.pprint')
Help on function pprint in pprint:

pprint.pprint = pprint(object, stream=None, indent=1, width=80, depth=None)
    Pretty-print a Python object to a stream [default is sys.stdout].

>>> from pprint import pprint
>>> for tree in [ (1, 2, 3, 4, 5, 6, 7, 8),
	          (1, (( 2, 3 ), (4, (5, ((6, 7), 8))))),
	          ((((1, 2), 3), 4), 5, 6, 7, 8) ]:
	print("\nTree %r can be pprint'd as:" % (tree, ))
	pprint(tree, indent=1, width=1)

	

Tree (1, 2, 3, 4, 5, 6, 7, 8) can be pprint'd as:
(1,
 2,
 3,
 4,
 5,
 6,
 7,
 8)

Tree (1, ((2, 3), (4, (5, ((6, 7), 8))))) can be pprint'd as:
(1,
 ((2,
   3),
  (4,
   (5,
    ((6,
      7),
     8)))))

Tree ((((1, 2), 3), 4), 5, 6, 7, 8) can be pprint'd as:
((((1,
    2),
   3),
  4),
 5,
 6,
 7,
 8)
>>>
