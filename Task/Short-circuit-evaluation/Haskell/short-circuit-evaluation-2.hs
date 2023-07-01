_     && False = False
False && True  = False
_     && _     = True

_     || True  = True
True  || False = True
_     || _     = False
