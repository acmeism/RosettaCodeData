#!/usr/bin/env io

ScriptedMain := Object clone
ScriptedMain meaningOfLife := 42

if( isLaunchScript,
    "Main: The meaning of life is #{ScriptedMain meaningOfLife}" interpolate println
)
