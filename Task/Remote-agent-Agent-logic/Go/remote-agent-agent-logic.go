package agent

import (
    "log"
    "math/rand"
    "time"

    "ra/ifc"
)

// The agent's awareness is quite limited.  It has no representation of the
// maze, which direction it is facing, or what it did last.  It notices and
// remembers just three things:  The color of the sector just entered, the
// presense and color of any ball there, and the presense and color of any
// ball it is holding.
var sectorColor, sectorBall, agentBall byte

// Package level variable to simplify function calls.
var stream ifc.Streamer

func Agent(s ifc.Streamer) {
    stream = s
    // randomness used for movement
    rand.Seed(time.Now().Unix())
    // handshake
    hs := stream.Rec()
    if hs != ifc.Handshake {
        log.Fatal("agent: thats no handshake")
    }
    stream.Send(ifc.Handshake)
    // agent behavior main loop
    for gameOver := false; !gameOver; {
        findMisplaced()
        get()
        findMatching()
        gameOver = drop()
    }
}

// noColor is not part of the interface or the world's representation.
// It is used by the agent as a test for receipt of a color-based event.
const noColor byte = '-'

// Move moves one sector in a random direction.
// It retries on bumps and doesn't return until a forward command succeeds.
// It expects a color event on a successful move and terminates if it doesn't
// get one.
func move() {
    for {
        // Randomness:  50/50 chance of turning or attempting move.
        // For turns, equal chance of turning right or left.
        switch rand.Intn(4) {
        case 0:
            stream.Send(ifc.CmdLeft)
            for stream.Rec() != ifc.EvStop {
            }
            continue
        case 1:
            stream.Send(ifc.CmdRight)
            for stream.Rec() != ifc.EvStop {
            }
            continue
        }
        stream.Send(ifc.CmdForward)
        bump := false
        sectorColor = noColor
        sectorBall = noColor
    events:
        for {
            switch ev := stream.Rec(); ev {
            case ifc.EvBump:
                bump = true
            case ifc.EvColorRed, ifc.EvColorGreen,
                ifc.EvColorYellow, ifc.EvColorBlue:
                sectorColor = ev
            case ifc.EvBallRed, ifc.EvBallGreen,
                ifc.EvBallYellow, ifc.EvBallBlue:
                sectorBall = ev
            case ifc.EvStop:
                break events
            }
        }
        if bump {
            continue
        }
        if sectorColor == noColor {
            log.Fatal("agent: expected color event after move")
        }
        return
    }
}

// FindMisplaced wanders the maze looking for a ball on the wrong sector.
func findMisplaced() {
    for {
        move()
        // get ball from current sector if meaningful
        switch sectorBall {
        case ifc.EvBallRed, ifc.EvBallGreen,
            ifc.EvBallYellow, ifc.EvBallBlue:
            if sectorBall != sectorColor+32 {
                return
            }
        }
    }
}

// Get is only called when get is possible.
func get() {
    stream.Send(ifc.CmdGet)
    for {
        switch stream.Rec() {
        case ifc.EvStop:
            // agent notes ball color, and that sector is now empty
            agentBall = sectorBall
            sectorBall = noColor
            return
        case ifc.EvNoBallInSector, ifc.EvAgentFull:
            log.Fatal("agent: expected get to succeed")
        }
    }
}

// There's a little heuristic built in to findMatching and drop.
// Ideally, findMatching finds an empty sector matching the ball that the
// agent is holding and then drop drops it there.  FindMatching returns
// with partial success however, if it finds a sector matching the ball
// where the sector is not empty, but contains a ball of the wrong color.
// In this case, drop will drop the ball on the nearest empty sector,
// in hopes that it has at least moved the ball near a sector where it
// might ultimately go.

// FindMatching is only called when agent has a ball.
// FindMatching finds a sector where the color matches the ball the agent
// is holding and which does not already contain a matching ball.
// It does not necessarily find an empty matching sector.
func findMatching() {
    for sectorColor+32 != agentBall || agentBall == sectorBall {
        move()
    }
}

// Drop is only called when the agent has a ball.  Unlike get() however,
// drop() can be called whether the sector is empty or not.  drop() means
// drop as soon as possible, so if the sector is full, drop() will wander
// at random looking for an empty sector.
func drop() (gameOver bool) {
    for sectorBall != noColor {
        move()
    }
    // expected to work
    stream.Send(ifc.CmdDrop)
ev:
    for {
        switch stream.Rec() {
        case ifc.EvGameOver:
            gameOver = true
        case ifc.EvStop:
            break ev
        case ifc.EvNoBallInAgent, ifc.EvSectorFull:
            log.Fatal("expected drop to succeed")
        }
    }
    sectorBall = agentBall
    agentBall = noColor
    return
}
