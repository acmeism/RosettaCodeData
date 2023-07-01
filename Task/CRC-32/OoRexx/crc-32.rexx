/* ooRexx */
clzCRC32=bsf.importClass("java.util.zip.CRC32")
myCRC32 =clzCRC32~new
toBeEncoded="The quick brown fox jumps over the lazy dog"
myCRC32~update(BsfRawBytes(toBeEncoded))
numeric digits 20
say 'The CRC-32 value of "'toBeEncoded'" is:' myCRC32~getValue~d2x

::requires "BSF.CLS"    -- get Java bridge
