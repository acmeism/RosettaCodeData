import qualified Data.Time.Clock.POSIX as P
import qualified Data.Time.Format as F

-- UTC from EST
main :: IO ()
main = print t2
  where
    t1 =
      F.parseTimeOrError
        True
        F.defaultTimeLocale
        "%B %e %Y %l:%M%P %Z"
        "March 7 2009 7:30pm EST"
    t2 = P.posixSecondsToUTCTime $ 12 * 60 * 60 + P.utcTimeToPOSIXSeconds t1
