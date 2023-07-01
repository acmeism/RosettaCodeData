module MorsePlaySox (play) where

import Sound.Sox.Play
import Sound.Sox.Option.Format
import Sound.Sox.Signal.List
import Data.Int
import System.Exit
import MorseCode

samps = 15           -- samples/cycle
freq  = 700          -- cycles/second (frequency)
rate  = samps * freq -- samples/second (sampling rate)

type Samples = [Int16]

-- One cycle of silence and a sine wave.
mute, sine :: Samples
mute = replicate samps 0
sine = let n = fromIntegral samps
           f k = 8000.0 * sin (2*pi*k/n)
       in map (round . f . fromIntegral) [0..samps-1]

-- Repeat samples until we have the specified duration in seconds.
rep :: Float -> Samples -> Samples
rep dur = take n . cycle
    where n = round (dur * fromIntegral rate)

-- Convert Morse symbols to samples.  Durations are in seconds, based on
-- http://en.wikipedia.org/wiki/Morse_code#Representation.2C_timing_and_speeds.
toSamples :: MSym -> Samples
toSamples Dot  = rep 0.1 sine
toSamples Dash = rep 0.3 sine
toSamples SGap = rep 0.1 mute
toSamples CGap = rep 0.3 mute
toSamples WGap = rep 0.7 mute

-- Interpret the stream of Morse symbols as sound.
play :: Morse -> IO ExitCode
play = simple put none rate . concatMap toSamples
