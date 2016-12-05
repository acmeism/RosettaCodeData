define rms(arr)
{
  return sqrt(sum(sqr(arr)) / length(arr));
}

print(rms([1:10]));
