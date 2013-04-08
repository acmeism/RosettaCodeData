#!/usr/bin/env python
# Example of using doc strings
"""My Doc-string example"""

class Foo:
     '''Some documentation for the Foo class'''
     def __init__(self):
        "Foo's initialization method's documentation"

def bar():
    """documentation for the bar function"""

if __name__ == "__main__":
    print (__doc__)
    print (Foo.__doc__)
    print (Foo.__init__.__doc__)
    print (bar.__doc__)
