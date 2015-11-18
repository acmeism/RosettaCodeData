use MONKEY-TYPING;
augment class Int {
    method times (&what) { what() xx self }  # pretend like we're Ruby
}
