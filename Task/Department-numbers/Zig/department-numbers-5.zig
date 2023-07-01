const SolutionIterator = struct {
    // 5 bit unsigned (u5) allows addition up to 31
    p: u5 = 2,
    s: u5 = 1,
    f: u5 = 0,

    /// 3 bit unsigned (u3) limits 0 <= department <= 7
    fn next(self: *SolutionIterator) ?struct { police: u3, sanitation: u3, fire: u3 } {
        if (self.p > 7) return null; // already completed

        while (true) {
            self.f += 1; // fire
            if (self.f > 7) {
                self.f = 1;
                self.s += 1; // sanitation
                if (self.s > 7) {
                    self.s = 1;
                    self.p += 2; // police
                    if (self.p > 7) {
                        return null; // completed
                    }
                }
            }
            if (self.p + self.f + self.s == 12)
                return .{
                    .police = @truncate(self.p),
                    .sanitation = @truncate(self.s),
                    .fire = @truncate(self.f),
                };
        }
    }
};
