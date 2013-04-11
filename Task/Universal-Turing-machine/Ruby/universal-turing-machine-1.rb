class Turing
    class Tape
        def initialize(symbols, blank, starting_tape)
            @symbols = symbols
            @blank = blank
            @tape = starting_tape
            @index = 0
        end
        def read
            retval = @tape[@index]
            unless retval
                retval = @tape[@index] = @blank
            end
            raise "invalid symbol '#{retval}' on tape" unless @tape.member?(retval)
            return retval
        end
        def write(symbol)
            @tape[@index] = symbol
        end
        def right
            @index += 1
        end
        def left
            if @index == 0
              @tape.unshift @blank
            else
              @index -= 1
            end
        end
        def stay
            # nop
        end
        def get_tape
            return @tape
        end
    end

    def initialize(symbols, blank,
                   initial_state, halt_states, running_states,
                   rules, starting_tape = [])
        @tape = Tape.new(symbols, blank, starting_tape)
        @initial_state = initial_state
        @halt_states = halt_states
        @running_states = running_states
        @rules = rules
        @halted = false
    end
    def run
        raise "machine already halted" if @halted
        state = @initial_state
        while (true)
            break if @halt_states.member? state
            raise "unknown state '#{state}'" unless @running_states.member? state
            symbol = @tape.read
            outsym, action, state = @rules[state][symbol]
            @tape.write outsym
            @tape.send action
        end
        @halted = true
        return @tape.get_tape
    end
end
