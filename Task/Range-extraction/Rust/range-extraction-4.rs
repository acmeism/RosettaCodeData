impl<'a, T> Iterator for RangeFinder<'a, T> where T: PartialEq + Add<T, Output=T> + Copy + One {
