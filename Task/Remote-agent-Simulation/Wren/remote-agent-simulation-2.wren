/* Remote_agent_driver.wren */

import "./ifc" for Streamer, Ifc, Log
import "./agent" for Agent
import "./world" for World
import "./queue" for Queue

// Concrete implementation of Streamer abstract class.
class QueueStreamer is Streamer {
    construct new(name, qin, qout) {
        _name = name
        _qin  = qin
        _qout = qout
    }

    send(ch) {
        Log.print("%(_name) sends %(Ifc.text[ch])")
        _qout.push(ch)
    }

    rec() {
        var ch = _qin.pop()
        if (ch) Log.print("%(_name) receives %(Ifc.text[ch])")
        return ch
    }
}

var cmd = Queue.new()
var ev  = Queue.new()

var aqs = QueueStreamer.new("agent", ev, cmd)
var wqs = QueueStreamer.new("world", cmd, ev)

var af = Fiber.new(Agent)
var wf = Fiber.new(World)

wf.call(wqs)

while(!wf.isDone) {
    af.call(aqs)
    wf.call(wqs)
}
