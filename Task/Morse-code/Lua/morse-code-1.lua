local M = {}

-- module-local variables
local BUZZER = pio.PB_10
local dit_length, dah_length, word_length

-- module-local functions
local buzz, dah, dit, init, inter_element_gap, medium_gap, pause, sequence, short_gap

buzz = function(duration)
  pio.pin.output(BUZZER)
  pio.pin.setlow(BUZZER)
  tmr.delay(tmr.SYS_TIMER, duration)
  pio.pin.sethigh(BUZZER)
  pio.pin.input(BUZZER)
end

dah = function()
  buzz(dah_length)
end

dit = function()
  buzz(dit_length)
end

init = function(baseline)
  dit_length = baseline
  dah_length = 2 * baseline
  word_length = 4 * baseline
end

inter_element_gap = function()
  pause(dit_length)
end

medium_gap = function()
  pause(word_length)
end

pause = function(duration)
  tmr.delay(tmr.SYS_TIMER, duration)
end

sequence = function(codes)
  if codes then
    for _,f in ipairs(codes) do
      f()
      inter_element_gap()
    end
    short_gap()
  end
end

short_gap = function()
  pause(dah_length)
end

local morse = {
  a = { dit, dah }, b = { dah, dit, dit, dit }, c = { dah, dit, dah, dit },
  d = { dah, dit, dit }, e = { dit }, f = { dit, dit, dah, dit },
  g = { dah, dah, dit }, h = { dit, dit, dit ,dit }, i = { dit, dit },
  j = { dit, dah, dah, dah }, k = { dah, dit, dah }, l = { dit, dah, dit, dit },
  m = { dah, dah }, n = { dah, dit }, o = { dah, dah, dah },
  p = { dit, dah, dah, dit }, q = { dah, dah, dit, dah }, r = { dit, dah, dit },
  s = { dit, dit, dit }, t = { dah }, u = { dit, dit, dah },
  v = { dit, dit, dit, dah }, w = { dit, dah, dah }, x = { dah, dit, dit, dah },
  y = { dah, dit, dah, dah }, z = { dah, dah, dit, dit },

  ["0"] = { dah, dah, dah, dah, dah }, ["1"] = { dit, dah, dah, dah, dah },
  ["2"] = { dit, dit, dah, dah, dah }, ["3"] = { dit, dit, dit, dah, dah },
  ["4"] = { dit, dit, dit, dit, dah }, ["5"] = { dit, dit, dit, dit, dit },
  ["6"] = { dah, dit, dit, dit, dit }, ["7"] = { dah, dah, dit, dit, dit },
  ["8"] = { dah, dah, dah, dit, dit }, ["9"] = { dah, dah, dah, dah, dit },

  [" "] = { medium_gap }
}

-- public interface
M.beep = function(message)
  message = message:lower()
  for _,ch in ipairs { message:byte(1, #message) } do
    sequence(morse[string.char(ch)])
  end
end

M.set_dit = function(duration)
  init(duration)
end

-- initialization code
init(50000)

return M
