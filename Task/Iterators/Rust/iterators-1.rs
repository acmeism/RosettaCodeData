struct FairDiceRoll;

impl Iterator for FairDiceRoll {
    type Item = i32;

    fn next(&mut self) -> Option<Self::Item> {
        Some(4)
    }
}
