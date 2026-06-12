#!/path/to/python
# Although `#!/usr/bin/env python` may be better if the path to python can change

import sys
print " ".join(sys.argv[1:])
