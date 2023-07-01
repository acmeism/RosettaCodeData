# Project: Introspection

if version() < 1.8
   see "Version is too old" + " (" + version() + ")" + nl
else
   see "Version is uptodate" + " (" + version() + ")" + nl
ok
bloop = 5
if isglobal("bloop") = 1
   see "Variable " + "'bloop'" + " exists" + nl
else
   see "Variable " + "'bloop'" + " doesn't exist" + nl
ok
if isglobal("bleep") = 1
   see "Variable " + "'bleep'" + " exists" + nl
else
   see "Variable " + "'bleep'" + " doesn't exist" + nl
ok
if isfunction("abs") = 1
   see "Function " + "'abs'" + " is defined" + nl
else
   see "Function " + "'abs'" + " is not defined" + nl
ok
if isfunction("abc") = 1
   see "Function " + "'abc'" + " is defined" + nl
else
   see "Function " + "'abc'" + " is not defined" + nl
ok

func abs(bloop)
        return fabs(bloop)
