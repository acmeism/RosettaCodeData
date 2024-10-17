struct Square {
    side_length: i32
}

impl Shape for Square {
    fn area(self) -> i32 {
        self.side_length * self.side_length
    }
}
