pub fn append<Out: FromIterator<String>, A: IntoIterator, B: IntoIterator, C: IntoIterator>(
    a: A,
    b: B,
    c: C,
) -> Out
where
    <A as IntoIterator>::Item: core::fmt::Display,
    <B as IntoIterator>::Item: core::fmt::Display,
    <C as IntoIterator>::Item: core::fmt::Display,
{
    core::iter::zip(a, core::iter::zip(b, c))
        .map(|(i, (j, k))| format!("{i}{j}{k}"))
        .collect()
}
