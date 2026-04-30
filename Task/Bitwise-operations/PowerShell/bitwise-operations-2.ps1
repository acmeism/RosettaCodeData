$X -shl $Y
# Arithmetic right shift
$X -shr $Y

# Requires quite a stretch of the imagination to call this "native" support of right rotate, but it works
[System.Security.Cryptography.SHA256Managed].GetMethod('RotateRight', 'NonPublic, Static', $null, @([UInt32], [Int32]), $null).Invoke($null, @([uint32]$X, $Y))
