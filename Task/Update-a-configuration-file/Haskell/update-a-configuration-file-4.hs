readIni :: String -> IO INI
readIni file = INI . map read . lines <$> S.readFile file

writeIni :: String -> INI -> IO ()
writeIni file = writeFile file . unlines . map show . entries

updateIni :: String -> (INI -> INI) -> IO ()
updateIni file f = readIni file >>= writeIni file . f

main = updateIni "test.ini" $
  disable "NeedsPeeling" .
  enable "SeedsRemoved" .
  setValue "NumberOfBananas" "1024" .
  setValue "NumberOfStrawberries" "62000"
