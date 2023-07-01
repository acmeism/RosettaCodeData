using System;

public static System.ReadOnlySpan<T> RemoveItems<T>(System.Span<T> toStrip, System.ReadOnlySpan<T> toRemove)
  where T : System.IEquatable<T>
{
  var toIndex = toStrip.Length;

  for (var fromIndex = toIndex - 1; fromIndex >= 0; fromIndex--)
    if (toStrip[fromIndex] is var item && !toRemove.Contains(item))
      toStrip[--toIndex] = item;

  return toStrip.Slice(toIndex);
}
