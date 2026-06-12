/* ifc.wren */

import "./fmt" for Fmt

// The Streamer abstract class defines how agent and world talk to each other.
// If implemented in Wren, send and rec will be synchronous blocking operations.
class Streamer {
    send(ch) {}
    rec()    {}
}

// The agent and world send and receive single characters, out of the set of
// constants defined here.
class Ifc {
    static handshake        { "H" }
    static cmdForward       { "^" }
    static cmdRight         { ">" }
    static cmdLeft          { "<" }
    static cmdGet           { "@" }
    static cmdDrop          { "!" }
    static evGameOver       { "+" }
    static evStop           { "." }
    static evColorRed       { "R" }
    static evColorGreen     { "G" }
    static evColorYellow    { "Y" }
    static evColorBlue      { "B" }
    static evBallRed        { "r" }
    static evBallGreen      { "g" }
    static evBallYellow     { "y" }
    static evBallBlue       { "b" }
    static evBump           { "|" }
    static evSectorFull     { "S" }
    static evAgentFull      { "A" }
    static evNoBallInSector { "s" }
    static evNoBallInAgent  { "a" }

    // Human readable text for the above commands and events.
    static init_() {
        __hrText = {
            handshake        : "handshake",
            cmdForward       : "command forward",
            cmdRight         : "command turn right",
            cmdLeft          : "command turn left",
            cmdGet           : "command get",
            cmdDrop          : "command drop",
            evGameOver       : "event game over",
            evStop           : "event stop",
            evColorRed       : "event color red",
            evColorGreen     : "event color green",
            evColorYellow    : "event color yellow",
            evColorBlue      : "event color blue",
            evBallRed        : "event ball red",
            evBallGreen      : "event ball green",
            evBallYellow     : "event ball yellow",
            evBallBlue       : "event ball blue",
            evBump           : "event bump",
            evSectorFull     : "event sector full",
            evAgentFull      : "event agent full",
            evNoBallInSector : "event no ball in sector",
            evNoBallInAgent  : "event no ball in agent"
        }
    }

    static text { __hrText }
}

class Log {
    static prefix=(p) { __prefix = Fmt.swrite("$06d: ", p) }

    static print(s) { System.print(__prefix + s) }

    static fatal(s) { Fiber.abort(s) }
}

Ifc.init_()
