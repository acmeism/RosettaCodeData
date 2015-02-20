function mean(a)
{
 return a.length ? Functional.reduce('+', 0, a) / a.length : 0;
}
