import Control.Concurrent (threadDelay, forkIO)
import Control.Concurrent.SampleVar

-- An Event is defined as a SampleVar with no data.
-- http://haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-SampleVar.html
newtype Event = Event (SampleVar ())

newEvent               = fmap Event (newEmptySampleVar)
signalEvent (Event sv) = writeSampleVar sv ()
resetEvent  (Event sv) = emptySampleVar sv
waitEvent   (Event sv) = readSampleVar  sv
