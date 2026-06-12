package main

import (
    "log"
    "os"

    "ra/agent"
    "ra/world"
)

// Concrete type chanStreamer implements interface ifc.Streamer.
// Implementaion is with channels, a simple way to demonstrate concurrency.
type chanStreamer struct {
    name string
    in   <-chan byte
    out  chan<- byte
}

// Send satisfies ifc.Streamer.Send method.
func (c chanStreamer) Send(b byte) {
    log.Print(c.name, " sends ", text[b])
    c.out <- b
}

// Rec satisfies ifc.Streamer.Rec method.
func (c chanStreamer) Rec() byte {
    b := <-c.in
    log.Print(c.name, " recieves ", text[b])
    return b
}

func main() {
    // Logging is done with the log package default logger, so this is
    // technically something that might be shared by the agent and the world.
    // Currently though, the agent doesn't do anything with the logger, only
    // the world does.
    log.SetFlags(0)
    log.SetOutput(os.Stdout)
    // Create channels for chanStreamer.  Only two channels are needed,
    // cmd going from agent to world, and ev going from world to agent.
    cmd := make(chan byte)
    ev := make(chan byte)
    // Instantiate chanStreamer for agent and start agent as a goroutine.
    // This allows it to run concurrently with the world.
    go agent.Agent(chanStreamer{"agent", ev, cmd})
    // World doesn't need another goroutine, it just takes over main at this
    // point.  The program terminates immediately when World returns.
    world.World(chanStreamer{"world", cmd, ev})
}
