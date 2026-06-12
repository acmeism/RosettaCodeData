package main

import "ra/ifc"

// Human readable text for commands and events.
var text = map[byte]string{
    ifc.CmdForward:       "command forward",
    ifc.CmdRight:         "command turn right",
    ifc.CmdLeft:          "command turn left",
    ifc.CmdGet:           "command get",
    ifc.CmdDrop:          "command drop",
    ifc.EvGameOver:       "event game over",
    ifc.EvStop:           "event stop",
    ifc.EvColorRed:       "event color red",
    ifc.EvColorGreen:     "event color green",
    ifc.EvColorYellow:    "event color yellow",
    ifc.EvColorBlue:      "event color blue",
    ifc.EvBallRed:        "event ball red",
    ifc.EvBallGreen:      "event ball green",
    ifc.EvBallYellow:     "event ball yellow",
    ifc.EvBallBlue:       "event ball blue",
    ifc.EvBump:           "event bump",
    ifc.EvSectorFull:     "event sector full",
    ifc.EvAgentFull:      "event agent full",
    ifc.EvNoBallInSector: "event no ball in sector",
    ifc.EvNoBallInAgent:  "event no ball in agent",
}
