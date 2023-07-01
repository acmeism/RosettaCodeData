{-# LANGUAGE QuasiQuotes #-}
import Text.RawString.QQ

"abc\ndef" == [r|abc
def|]
