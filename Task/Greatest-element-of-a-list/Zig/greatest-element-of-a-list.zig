fn max( a: []const f32) f32{
  var output = a[0];
  for(a)|num|{
    output = @max(output, num);
  }
return output;
}
