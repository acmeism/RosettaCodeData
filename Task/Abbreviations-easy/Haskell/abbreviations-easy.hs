import Data.Maybe (fromMaybe)
import Data.List (find, isPrefixOf)
import Data.Char (toUpper, isUpper)

isAbbreviationOf :: String -> String -> Bool
isAbbreviationOf abbreviation command =
  minimumPrefix `isPrefixOf` normalizedAbbreviation
  && normalizedAbbreviation `isPrefixOf` normalizedCommand
  where
    normalizedAbbreviation = map toUpper abbreviation
    normalizedCommand = map toUpper command
    minimumPrefix = takeWhile isUpper command


expandAbbreviation :: String -> String -> Maybe String
expandAbbreviation commandTable abbreviation = do
  command <- find (isAbbreviationOf abbreviation) (words commandTable)
  return $ map toUpper command


commandTable = unwords [
  "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy",
  "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find",
  "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput",
  "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO",
  "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT",
  "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT",
  "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"]


main :: IO ()
main = do
  input <- getLine
  let abbreviations = words input
  let commands = map (fromMaybe "*error*" . expandAbbreviation commandTable) abbreviations
  putStrLn $ unwords results
