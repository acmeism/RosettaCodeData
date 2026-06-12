#!/bin/sh
"true" '''\'
if [ -L $0 ]; then
...
exec "$interpreter" "$@"
exit 127
'''

__doc__ = """module docstring"""

print "Hello World"
