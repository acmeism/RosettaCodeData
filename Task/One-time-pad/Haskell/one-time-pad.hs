-- To compile into an executable:
-- ghc -main-is OneTimePad OneTimePad.hs
-- To run:
-- ./OneTimePad --help

module OneTimePad (main) where

import           Control.Monad
import           Data.Char
import           Data.Function         (on)
import qualified Data.Text             as T
import qualified Data.Text.IO          as TI
import           Data.Time
import           System.Console.GetOpt
import           System.Environment
import           System.Exit
import           System.IO

-- Command-line options parsing
data Options = Options  { optCommand :: String
                        , optInput   :: IO T.Text
                        , optOutput  :: T.Text -> IO ()
                        , optPad     :: (IO T.Text, T.Text -> IO ())
                        , optLines   :: Int
                        }

startOptions :: Options
startOptions = Options  { optCommand    = "decrypt"
                        , optInput      = TI.getContents
                        , optOutput     = TI.putStr
                        , optPad        = (TI.getContents, TI.putStr)
                        , optLines      = 0
                        }

options :: [ OptDescr (Options -> IO Options) ]
options =
    [ Option "e" ["encrypt"]
        (NoArg
            (\opt -> return opt { optCommand = "encrypt" }))
        "Encrypt file"
    , Option "d" ["decrypt"]
        (NoArg
            (\opt -> return opt { optCommand = "decrypt" }))
        "Decrypt file (default)"
    , Option "g" ["generate"]
        (NoArg
            (\opt -> return opt { optCommand = "generate" }))
        "Generate a one-time pad"
    , Option "i" ["input"]
        (ReqArg
            (\arg opt -> return opt { optInput = TI.readFile arg })
            "FILE")
        "Input file (for decryption and encryption)"
    , Option "o" ["output"]
        (ReqArg
            (\arg opt -> return opt { optOutput = TI.writeFile arg })
            "FILE")
        "Output file (for generation, decryption, and encryption)"
    , Option "p" ["pad"]
        (ReqArg
            (\arg opt -> return opt { optPad = (TI.readFile arg,
                                                TI.writeFile arg) })
            "FILE")
        "One-time pad to use (for decryption and encryption)"
    , Option "l" ["lines"]
        (ReqArg
            (\arg opt -> return opt { optLines = read arg :: Int })
            "LINES")
        "New one-time pad's length (in lines of 48 characters) (for generation)"
    , Option "V" ["version"]
        (NoArg
            (\_ -> do
                hPutStrLn stderr "Version 0.01"
                exitWith ExitSuccess))
        "Print version"
    , Option "h" ["help"]
        (NoArg
            (\_ -> do
                prg <- getProgName
                putStrLn "usage: OneTimePad [-h] [-V] [--lines LINES] [-i FILE] [-o FILE] [-p FILE] [--encrypt | --decrypt | --generate]"
                hPutStrLn stderr (usageInfo prg options)
                exitWith ExitSuccess))
        "Show this help message and exit"
    ]

main :: IO ()
main = do
  args <- getArgs
  let (actions, nonOptions, errors) = getOpt RequireOrder options args
  opts <- Prelude.foldl (>>=) (return startOptions) actions
  let Options { optCommand = command
              , optInput   = input
              , optOutput  = output
              , optPad     = (inPad, outPad)
              , optLines   = linecnt } = opts

  case command of
    "generate" -> generate linecnt output
    "encrypt"  -> do
      inputContents <- clean <$> input
      padContents <- inPad
      output $ format $ encrypt inputContents $ unformat $ T.concat
        $ dropWhile (\t -> T.head t == '-' || T.head t == '#')
        $ T.lines padContents
    "decrypt"  -> do
      inputContents <- unformat <$> input
      padContents <- inPad
      output $ decrypt inputContents $ unformat $ T.concat
        $ dropWhile (\t -> T.head t == '-' || T.head t == '#')
        $ T.lines padContents
      let discardLines = ceiling
            $ ((/) `on` fromIntegral) (T.length inputContents) 48
      outPad $ discard discardLines $ T.lines padContents

{- | Discard used pad lines. Is only called at decryption to enable using the
same pad file for both encryption and decryption.
-}
discard :: Int -> [T.Text] -> T.Text
discard 0 ts = T.unlines ts
discard x (t:ts) = if (T.head t == '-' || T.head t == '#')
  then T.unlines [t, (discard x ts)]
  else T.unlines [(T.append (T.pack "- ") t), (discard (x-1) ts)]

{- | Clean the text from symbols that cannot be encrypted.
-}
clean :: T.Text -> T.Text
clean = T.map toUpper . T.filter (\c -> let oc = ord c
                                   in oc >= 65 && oc <= 122
                                   && (not $ oc >=91 && oc <= 96))

{- | Format text (usually encrypted text) for pretty-printing it in a similar
way to the example from Wikipedia (see Rosetta Code page for this task)
-}
format :: T.Text -> T.Text
format = T.unlines . map (T.intercalate (T.pack " ") . T.chunksOf 6)
  . T.chunksOf 48

{- | Unformat encrypted text, getting rid of characters that are irrelevant for
decryption.
-}
unformat :: T.Text -> T.Text
unformat = T.filter (\c -> c/='\n' && c/=' ')

{- | Generate a one-time pad and write it to file (specified as second
parameter). Note: this only works on operating systems that have the
"/dev/random" file.
-}
generate :: Int -> (T.Text -> IO ()) -> IO ()
generate lines output = do
  withBinaryFile "/dev/random" ReadMode
    (\handle -> do
        contents <- replicateM (48 * lines) $ hGetChar handle
        time <- getCurrentTime
        output
          $ T.unlines [ T.pack
                        $ "# OTP pad, generated by https://github.com/kssytsrk/one-time-pad on "
                        ++ show time
                      , format $ T.pack
                        $ map (chr . (65 +) . flip mod 26 . ord) contents
                      ])

-- Helper function for encryption/decryption.
crypt :: (Int -> Int -> Int) -> T.Text -> T.Text -> T.Text
crypt f = T.zipWith ((chr .) . f `on` ord)

-- Encrypt first parameter's contents, using the second parameter as a key.
encrypt :: T.Text -> T.Text -> T.Text
encrypt = crypt ((((+65) . flip mod 26 . subtract 130) .) . (+))

-- Decrypt first parameter's contents, using the second parameter as a key.
decrypt :: T.Text -> T.Text -> T.Text
decrypt = crypt ((((+65) . flip mod 26) .) . (-))
