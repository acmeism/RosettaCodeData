require "math"
require "time"

# this enum allows us to specify what type of message the proc_chan received.
# this trivial example only has one action, but more enum members can be added
# to update the proc, or take other actions
enum Action
  Finished  # we've waited long enough, and are asking for our result
  # Update  # potential member representing an update to the integrator function
end

class Integrator
  property interval : Float64
  getter s : Float64 = 0f64

  # initialize our k function as a proc that takes a float and just returns 0
  getter k : Proc(Float64, Float64) = ->(t : Float64) { 0f64 }

  # channels used for communicating with the main fiber
  @proc_chan : Channel(Tuple(Action, Proc(Float64, Float64)|Nil))
  @result_chan : Channel(Float64)

  def initialize(@k, @proc_chan, @result_chan, @interval = 1e-4)
    # use a monotonic clock for accuracy
    start = Time.monotonic.total_seconds
    t0, k0 = 0f64, @k.call(0f64)

    loop do
      # this sleep returns control to the main fiber. if the main fiber hasn't finished sleeping,
      # control will be returned to this loop
      sleep interval.seconds
      # check the channel to see if the function has changed
      self.check_channel()
      t1 = Time.monotonic.total_seconds - start
      k1 = @k.call(t1)
      @s += (k1 + k0) * (t1 - t0) / 2.0
      t0, k0 = t1, k1
    end
  end

  # check the proc_chan for messages, update the integrator function or send the result as needed
  def check_channel
    select
    when message = @proc_chan.receive
      action, new_k = message
      case action
      when Action::Finished
        @result_chan.send @s
        @k = new_k unless new_k.nil?
      end
    else
      nil
    end
  end
end

# this channel allows us to update the integrator function,
# and inform the integrator to send the result over the result channel
proc_chan = Channel(Tuple(Action, Proc(Float64, Float64)|Nil)).new

# channel used to return the result from the integrator
result_chan = Channel(Float64).new

# run everything in a new top-level fiber to avoid shared memory issues.
# since the fiber immediately sleeps, control is returned to the main code.
# the main code then sleeps for two seconds, returning control to our state_clock fiber.
# when two seconds is up, this state_clock fiber will return control
# to the main code on the next `sleep interval.seconds`
spawn name: "state_clock" do
  ai = Integrator.new ->(t : Float64) { Math.sin(Math::PI * t) }, proc_chan, result_chan
end

sleep 2.seconds
proc_chan.send({Action::Finished, ->(t : Float64) { 0f64 }})
sleep 0.5.seconds
puts result_chan.receive
