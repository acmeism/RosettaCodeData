using System;
using System.Globalization;

struct LimitedInt : IComparable, IComparable<LimitedInt>, IConvertible, IEquatable<LimitedInt>, IFormattable
{
    const int MIN_VALUE = 1;
    const int MAX_VALUE = 10;

    public static readonly LimitedInt MinValue = new LimitedInt(MIN_VALUE);
    public static readonly LimitedInt MaxValue = new LimitedInt(MAX_VALUE);

    static bool IsValidValue(int value) => value >= MIN_VALUE && value <= MAX_VALUE;

    readonly int _value;
    public int Value => this._value == 0 ? MIN_VALUE : this._value; // Treat the default, 0, as being the minimum value.

    public LimitedInt(int value)
    {
        if (!IsValidValue(value))
            throw new ArgumentOutOfRangeException(nameof(value), value, $"Value must be between {MIN_VALUE} and {MAX_VALUE}.");
        this._value = value;
    }

    #region IComparable
    public int CompareTo(object obj)
    {
        if (obj is LimitedInt l) return this.Value.CompareTo(l);
        throw new ArgumentException("Object must be of type " + nameof(LimitedInt), nameof(obj));
    }
    #endregion

    #region IComparable<LimitedInt>
    public int CompareTo(LimitedInt other) => this.Value.CompareTo(other.Value);
    #endregion

    #region IConvertible
    public TypeCode GetTypeCode() => this.Value.GetTypeCode();
    bool IConvertible.ToBoolean(IFormatProvider provider) => ((IConvertible)this.Value).ToBoolean(provider);
    byte IConvertible.ToByte(IFormatProvider provider) => ((IConvertible)this.Value).ToByte(provider);
    char IConvertible.ToChar(IFormatProvider provider) => ((IConvertible)this.Value).ToChar(provider);
    DateTime IConvertible.ToDateTime(IFormatProvider provider) => ((IConvertible)this.Value).ToDateTime(provider);
    decimal IConvertible.ToDecimal(IFormatProvider provider) => ((IConvertible)this.Value).ToDecimal(provider);
    double IConvertible.ToDouble(IFormatProvider provider) => ((IConvertible)this.Value).ToDouble(provider);
    short IConvertible.ToInt16(IFormatProvider provider) => ((IConvertible)this.Value).ToInt16(provider);
    int IConvertible.ToInt32(IFormatProvider provider) => ((IConvertible)this.Value).ToInt32(provider);
    long IConvertible.ToInt64(IFormatProvider provider) => ((IConvertible)this.Value).ToInt64(provider);
    sbyte IConvertible.ToSByte(IFormatProvider provider) => ((IConvertible)this.Value).ToSByte(provider);
    float IConvertible.ToSingle(IFormatProvider provider) => ((IConvertible)this.Value).ToSingle(provider);
    string IConvertible.ToString(IFormatProvider provider) => this.Value.ToString(provider);
    object IConvertible.ToType(Type conversionType, IFormatProvider provider) => ((IConvertible)this.Value).ToType(conversionType, provider);
    ushort IConvertible.ToUInt16(IFormatProvider provider) => ((IConvertible)this.Value).ToUInt16(provider);
    uint IConvertible.ToUInt32(IFormatProvider provider) => ((IConvertible)this.Value).ToUInt32(provider);
    ulong IConvertible.ToUInt64(IFormatProvider provider) => ((IConvertible)this.Value).ToUInt64(provider);
    #endregion

    #region IEquatable<LimitedInt>
    public bool Equals(LimitedInt other) => this == other;
    #endregion

    #region IFormattable
    public string ToString(string format, IFormatProvider formatProvider) => this.Value.ToString(format, formatProvider);
    #endregion

    #region operators
    public static bool operator ==(LimitedInt left, LimitedInt right) => left.Value == right.Value;
    public static bool operator !=(LimitedInt left, LimitedInt right) => left.Value != right.Value;
    public static bool operator <(LimitedInt left, LimitedInt right) => left.Value < right.Value;
    public static bool operator >(LimitedInt left, LimitedInt right) => left.Value > right.Value;
    public static bool operator <=(LimitedInt left, LimitedInt right) => left.Value <= right.Value;
    public static bool operator >=(LimitedInt left, LimitedInt right) => left.Value >= right.Value;

    public static LimitedInt operator ++(LimitedInt left) => (LimitedInt)(left.Value + 1);
    public static LimitedInt operator --(LimitedInt left) => (LimitedInt)(left.Value - 1);

    public static LimitedInt operator +(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value + right.Value);
    public static LimitedInt operator -(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value - right.Value);
    public static LimitedInt operator *(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value * right.Value);
    public static LimitedInt operator /(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value / right.Value);
    public static LimitedInt operator %(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value % right.Value);

    public static LimitedInt operator &(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value & right.Value);
    public static LimitedInt operator |(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value | right.Value);
    public static LimitedInt operator ^(LimitedInt left, LimitedInt right) => (LimitedInt)(left.Value ^ right.Value);
    public static LimitedInt operator ~(LimitedInt left) => (LimitedInt)~left.Value;

    public static LimitedInt operator >>(LimitedInt left, int right) => (LimitedInt)(left.Value >> right);
    public static LimitedInt operator <<(LimitedInt left, int right) => (LimitedInt)(left.Value << right);

    public static implicit operator int(LimitedInt value) => value.Value;
    public static explicit operator LimitedInt(int value)
    {
        if (!IsValidValue(value)) throw new OverflowException();
        return new LimitedInt(value);
    }
    #endregion

    public bool TryFormat(Span<char> destination, out int charsWritten, ReadOnlySpan<char> format = default, IFormatProvider provider = null)
        => this.Value.TryFormat(destination, out charsWritten, format, provider);

    public override int GetHashCode() => this.Value.GetHashCode();
    public override bool Equals(object obj) => obj is LimitedInt l && this.Equals(l);
    public override string ToString() => this.Value.ToString();

    #region static methods
    public static bool TryParse(ReadOnlySpan<char> s, out int result) => int.TryParse(s, out result);
    public static bool TryParse(ReadOnlySpan<char> s, NumberStyles style, IFormatProvider provider, out int result) => int.TryParse(s, style, provider, out result);
    public static int Parse(string s, IFormatProvider provider) => int.Parse(s, provider);
    public static int Parse(string s, NumberStyles style, IFormatProvider provider) => int.Parse(s, style, provider);
    public static bool TryParse(string s, NumberStyles style, IFormatProvider provider, ref int result) => int.TryParse(s, style, provider, out result);
    public static int Parse(string s) => int.Parse(s);
    public static int Parse(string s, NumberStyles style) => int.Parse(s, style);
    public static int Parse(ReadOnlySpan<char> s, NumberStyles style = NumberStyles.Integer, IFormatProvider provider = null) => int.Parse(s, style, provider);
    public static bool TryParse(string s, ref int result) => int.TryParse(s, out result);
    #endregion
}
