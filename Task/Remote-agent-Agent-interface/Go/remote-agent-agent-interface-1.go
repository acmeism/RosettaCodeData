package ifc

// Streamer interface type defines how agent and world talk to each other.
//
// Send and Rec may be implemented as synchronous blocking operations.
// They can be considered perfectly reliable as there is no acknowledgement
// or timeout mechanism.
type Streamer interface {
    Send(byte)
    Rec() byte
}

// The agent and world send and receive single bytes, out of the set of
// constants defined here.
const Handshake = 'A'

const (
    CmdForward       = '^'
    CmdRight         = '>'
    CmdLeft          = '<'
    CmdGet           = '@'
    CmdDrop          = '!'
    EvGameOver       = '+'
    EvStop           = '.'
    EvColorRed       = 'R'
    EvColorGreen     = 'G'
    EvColorYellow    = 'Y'
    EvColorBlue      = 'B'
    EvBallRed        = 'r'
    EvBallGreen      = 'g'
    EvBallYellow     = 'y'
    EvBallBlue       = 'b'
    EvBump           = '|'
    EvSectorFull     = 'S'
    EvAgentFull      = 'A'
    EvNoBallInSector = 's'
    EvNoBallInAgent  = 'a'
)
