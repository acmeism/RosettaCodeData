import Text.PhoneticCode.Soundex

main :: IO ()
main =
  mapM_ print $
  ((,) <*> soundexSimple) <$> ["Soundex", "Example", "Sownteks", "Ekzampul"]
