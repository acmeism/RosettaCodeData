IF EXIST %filename% (
  del %filename%
) ELSE (
  echo %filename% not found
)
