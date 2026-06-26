struct Range {
    begin: i32,
    last: i32,
    step: i32,
}

impl Range {
    fn new(begin: i32, last: i32) -> Self {
        Self {
            begin,
            last,
            step: 1,
        }
    }

    fn step_by(self, step: i32) -> Range {
        Range { step, ..self }
    }
}

impl Iterator for Range {
    type Item = i32;

    fn next(&mut self) -> Option<Self::Item> {
        if self.step.is_negative() && self.begin < self.last
            || self.step.is_positive() && self.begin > self.last
        {
            return None;
        }

        let i = self.begin;
        self.begin += self.step;

        Some(i)
    }
}
