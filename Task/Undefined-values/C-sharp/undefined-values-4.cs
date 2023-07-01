Nullable<int> answer = new Nullable<int>();
if (!answer.HasValue) {
    answer = new Nullable<int>(42);
}
