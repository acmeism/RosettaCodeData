import System.FilePath.Posix (FilePath, takeExtension)

fps :: [FilePath]
fps =
  [ "http://example.com/download.tar.gz",
    "CharacterModel.3DS",
    ".desktop",
    "document",
    "document.txt_backup",
    "/etc/pam.d/login"
  ]

main :: IO ()
main = mapM_ (print . takeExtension) fps
