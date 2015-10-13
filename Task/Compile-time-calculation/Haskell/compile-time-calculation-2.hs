{-# LANGUAGE TemplateHaskell #-}
import Factorial

main = print $(factQ 10)
