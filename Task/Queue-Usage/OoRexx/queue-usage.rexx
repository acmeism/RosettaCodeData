q = .queue~new      -- create an instance
q~queue(3)          -- adds to the end, but this is at the front
q~push(1)           -- push on the front
q~queue(2)          -- add to the end
say q~pull q~pull q~pull q~isempty  -- should display all and be empty
