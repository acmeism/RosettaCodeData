set(x 42)
set(_SWAP_TEMPORARY "string")
swap(x _SWAP_TEMPORARY)
message(STATUS ${x})                # -- 42
message(STATUS ${_SWAP_TEMPORARY})  # -- 42
