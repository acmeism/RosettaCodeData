import osproc

# Output string and error code
let (lsalStr, errCode) = execCmdEx("ls -al")

echo "Error code: " & $errCode
echo "Output: " & lsalStr


# Output string only
let lsStr = execProcess("ls")

echo "Output: " & lsStr
