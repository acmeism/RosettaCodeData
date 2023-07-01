shuffleBS :: Int -> ByteString -> IO ByteString
shuffleBS n s =
  yieldMany (unpack s)
  =$ shuffleC n
  =$ mapC charUtf8
  =$ builderToByteString
  $$ foldC

main :: IO ()
main =
  sourceHandle stdin
  =$ mapMC (shuffleBS 10)
  $$ sinkHandle stdout
