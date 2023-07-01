(let [crc (new java.util.zip.CRC32)
      str "The quick brown fox jumps over the lazy dog"]
  (. crc update (. str getBytes))
  (printf "CRC-32('%s') = %s\n" str (Long/toHexString (. crc getValue))))
