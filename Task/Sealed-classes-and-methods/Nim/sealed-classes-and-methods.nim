type T1 = object                  # Non inheritable.
type T2 = object of RootObj       # Inherits from Root and is inheritable.
type T3 {.inheritable.} = object  # New object root which is inheritable.

type T4 = object of T2            # Inheritable.
type T5 = object of T3            # Inheritable.
type T6 {.final.} = object of T2  # Non inheritable.
