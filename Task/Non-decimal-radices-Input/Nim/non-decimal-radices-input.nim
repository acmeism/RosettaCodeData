import strutils

echo parseInt "10"       # 10

echo parseHexInt "0x10"  # 16
echo parseHexInt "10"    # 16

echo parseOctInt "0o120" # 80
echo parseOctInt "120"   # 80
