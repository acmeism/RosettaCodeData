 impl<'a, T> Iterator for RangeFinder<'a, T> where T: PartialEq + Add<i8, Output=T> + Copy {
