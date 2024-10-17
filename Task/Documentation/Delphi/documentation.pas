type
  /// <summary>Sample class.</summary>
  TMyClass = class
  public
    /// <summary>Converts a string into a number.</summary>
    /// <param name="aValue">String parameter</param>
    /// <returns>Numeric equivalent of aValue</returns>
    /// <exception cref="EConvertError">aValue is not a valid integer.</exception>
    function StringToNumber(aValue: string): Integer;
  end;
