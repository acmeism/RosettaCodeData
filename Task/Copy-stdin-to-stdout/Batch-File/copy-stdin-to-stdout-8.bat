@setlocal enabledelayedexpansion
@<con (for /l %%# in (0 0 1) do @set/p input=&echo:!input!)
