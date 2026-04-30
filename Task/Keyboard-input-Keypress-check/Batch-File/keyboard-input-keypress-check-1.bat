for /f skip^=1^ eol^= %a in ('replace /W ? . 2^>nul ^| find /v "Replacing"') do @echo:%a
