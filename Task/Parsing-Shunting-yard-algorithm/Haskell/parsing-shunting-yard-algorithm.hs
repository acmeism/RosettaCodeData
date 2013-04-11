import qualified Data.Map as M
import Text.Printf
import Data.List
import System.Environment

data Assoc = L | R deriving (Eq, Show)
data Op = Op Assoc Int

ops = M.fromList [("^", Op R 4)
                 ,("*", Op L 3),("/", Op L 3)
                 ,("+", Op L 2),("-", Op L 2)]

assoc t = case M.lookup t ops of
            Just (Op a p) -> a
            Nothing -> error "Bad lookup (assoc)"

prec t = case M.lookup t ops of
            Just (Op a p) -> p
            Nothing -> error "Bad lookup (prec)"

isDouble t = case reads t :: [(Double, String)] of
                [(_, "")] -> True
                _        -> False

finish (vs, fs, xs, _) = ((reverse fs ++ vs), [], xs, "Finished")

eval xs = (intermediates ++ [(finish $ last intermediates)])
    where intermediates = scanl f ([], [], words xs, "").words $ xs
          f (vs, fs, ts, msg) t  | isDouble t = ((t:vs), fs, tail ts, "Writing '"
                                                  ++ t)
                                 | t `M.member` ops = pushOp t (vs, fs, ts, msg)
                                 | t == "("   = (vs, (t:fs), tail ts, "Pushing '('")
                                 | t == ")"   = (((takeWhile (/="(") fs) ++ vs),
                                                 (tail $ dropWhile (/="(") fs),
                                                  tail ts, "Writing ops till ')'")

pushOp op1 (vs, fs, ts, msg) = if op2isOp &&
                                   ((assoc op1 == L && prec op1 <= prec op2) ||
                                    (prec op1 < prec op2))
                              then ((op2:vs), (op1:tail fs), tail ts,
                                                "Writing '" ++ op2 ++
                                                    "', pushing " ++ op1)
                              else (vs, (op1:fs), tail ts, "Pushing '" ++ op1 ++ "'")
     where (op2isOp, op2) = ((not $ null fs) && (op2 `M.member` ops), head fs)

showData (vs, fs, xs, msg) = concat [printf "%30s" (intercalate " " (reverse vs)) , "  "
                                     ,printf "%10s" (intercalate " " fs) , " "
                                     ,printf "%35s" (intercalate " " xs) , " "
                                     ,printf "%s" msg]

showAll xs = intercalate "\n" $ map showData xs

main = do putStrLn.showAll.eval $ "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
