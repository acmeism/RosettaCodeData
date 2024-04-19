for n in 5 .. 9:                 # 5 to 9 (9-inclusive)
  echo n

echo "" # spacer

for n in 5 ..< 9:                # 5 to 9 (9-exclusive)
  echo n

echo "" # spacer

for n in countup(0, 16, 4):      # 0 to 16 step 4
  echo n

echo "" # spacer

for n in countdown(16, 0, 4):    # 16 to 0 step -4
  echo n
