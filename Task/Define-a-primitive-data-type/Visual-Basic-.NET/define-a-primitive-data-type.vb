Structure LimitedInt
    Implements IComparable, IComparable(Of LimitedInt), IConvertible, IEquatable(Of LimitedInt), IFormattable

    Private Const MIN_VALUE = 1
    Private Const MAX_VALUE = 10

    Shared ReadOnly MinValue As New LimitedInt(MIN_VALUE)
    Shared ReadOnly MaxValue As New LimitedInt(MAX_VALUE)

    Private Shared Function IsValidValue(value As Integer) As Boolean
        Return value >= MIN_VALUE AndAlso value <= MAX_VALUE
    End Function

    Private ReadOnly _value As Integer
    ReadOnly Property Value As Integer
        Get
            ' Treat the default, 0, as being the minimum value.
            Return If(Me._value = 0, MIN_VALUE, Me._value)
        End Get
    End Property

    Sub New(value As Integer)
        If Not IsValidValue(value) Then Throw New ArgumentOutOfRangeException(NameOf(value), value, $"Value must be between {MIN_VALUE} and {MAX_VALUE}.")
        Me._value = value
    End Sub

#Region "IComparable"
    Function CompareTo(obj As Object) As Integer Implements IComparable.CompareTo
        If TypeOf obj IsNot LimitedInt Then Throw New ArgumentException("Object must be of type " + NameOf(LimitedInt), NameOf(obj))
        Return Me.CompareTo(DirectCast(obj, LimitedInt))
    End Function
#End Region

#Region "IComparable(Of LimitedInt)"
    Function CompareTo(other As LimitedInt) As Integer Implements IComparable(Of LimitedInt).CompareTo
        Return Me.Value.CompareTo(other.Value)
    End Function
#End Region

#Region "IConvertible"
    Function GetTypeCode() As TypeCode Implements IConvertible.GetTypeCode
        Return Me.Value.GetTypeCode()
    End Function

    Private Function ToBoolean(provider As IFormatProvider) As Boolean Implements IConvertible.ToBoolean
        Return DirectCast(Me.Value, IConvertible).ToBoolean(provider)
    End Function

    Private Function ToByte(provider As IFormatProvider) As Byte Implements IConvertible.ToByte
        Return DirectCast(Me.Value, IConvertible).ToByte(provider)
    End Function

    Private Function ToChar(provider As IFormatProvider) As Char Implements IConvertible.ToChar
        Return DirectCast(Me.Value, IConvertible).ToChar(provider)
    End Function

    Private Function ToDateTime(provider As IFormatProvider) As Date Implements IConvertible.ToDateTime
        Return DirectCast(Me.Value, IConvertible).ToDateTime(provider)
    End Function

    Private Function ToDecimal(provider As IFormatProvider) As Decimal Implements IConvertible.ToDecimal
        Return DirectCast(Me.Value, IConvertible).ToDecimal(provider)
    End Function

    Private Function ToDouble(provider As IFormatProvider) As Double Implements IConvertible.ToDouble
        Return DirectCast(Me.Value, IConvertible).ToDouble(provider)
    End Function

    Private Function ToInt16(provider As IFormatProvider) As Short Implements IConvertible.ToInt16
        Return DirectCast(Me.Value, IConvertible).ToInt16(provider)
    End Function

    Private Function ToInt32(provider As IFormatProvider) As Integer Implements IConvertible.ToInt32
        Return DirectCast(Me.Value, IConvertible).ToInt32(provider)
    End Function

    Private Function ToInt64(provider As IFormatProvider) As Long Implements IConvertible.ToInt64
        Return DirectCast(Me.Value, IConvertible).ToInt64(provider)
    End Function

    Private Function ToSByte(provider As IFormatProvider) As SByte Implements IConvertible.ToSByte
        Return DirectCast(Me.Value, IConvertible).ToSByte(provider)
    End Function

    Private Function ToSingle(provider As IFormatProvider) As Single Implements IConvertible.ToSingle
        Return DirectCast(Me.Value, IConvertible).ToSingle(provider)
    End Function

    Private Overloads Function ToString(provider As IFormatProvider) As String Implements IConvertible.ToString
        Return Me.Value.ToString(provider)
    End Function

    Private Function ToType(conversionType As Type, provider As IFormatProvider) As Object Implements IConvertible.ToType
        Return DirectCast(Me.Value, IConvertible).ToType(conversionType, provider)
    End Function

    Private Function ToUInt16(provider As IFormatProvider) As UShort Implements IConvertible.ToUInt16
        Return DirectCast(Me.Value, IConvertible).ToUInt16(provider)
    End Function

    Private Function ToUInt32(provider As IFormatProvider) As UInteger Implements IConvertible.ToUInt32
        Return DirectCast(Me.Value, IConvertible).ToUInt32(provider)
    End Function

    Private Function ToUInt64(provider As IFormatProvider) As ULong Implements IConvertible.ToUInt64
        Return DirectCast(Me.Value, IConvertible).ToUInt64(provider)
    End Function
#End Region

#Region "IEquatable(Of LimitedInt)"
    Overloads Function Equals(other As LimitedInt) As Boolean Implements IEquatable(Of LimitedInt).Equals
        Return Me = other
    End Function
#End Region

#Region "IFormattable"
    Private Overloads Function ToString(format As String, formatProvider As IFormatProvider) As String Implements IFormattable.ToString
        Return Me.Value.ToString(format, formatProvider)
    End Function
#End Region

#Region "Operators"
    Shared Operator =(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value = right.Value
    End Operator

    Shared Operator <>(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value <> right.Value
    End Operator

    Shared Operator <(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value < right.Value
    End Operator

    Shared Operator >(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value > right.Value
    End Operator

    Shared Operator <=(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value <= right.Value
    End Operator

    Shared Operator >=(left As LimitedInt, right As LimitedInt) As Boolean
        Return left.Value >= right.Value
    End Operator

    Shared Operator +(left As LimitedInt) As LimitedInt
        Return CType(+left.Value, LimitedInt)
    End Operator

    Shared Operator -(left As LimitedInt) As LimitedInt
        Return CType(-left.Value, LimitedInt)
    End Operator

    Shared Operator +(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value + right.Value, LimitedInt)
    End Operator

    Shared Operator -(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value - right.Value, LimitedInt)
    End Operator

    Shared Operator *(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value * right.Value, LimitedInt)
    End Operator

    Shared Operator /(left As LimitedInt, right As LimitedInt) As Double
        Return left.Value / right.Value
    End Operator

    Shared Operator \(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value \ right.Value, LimitedInt)
    End Operator

    Shared Operator ^(left As LimitedInt, right As LimitedInt) As Double
        Return left.Value ^ right.Value
    End Operator

    Shared Operator Mod(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value Mod right.Value, LimitedInt)
    End Operator

    Shared Operator And(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value And right.Value, LimitedInt)
    End Operator

    Shared Operator Or(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value Or right.Value, LimitedInt)
    End Operator

    Shared Operator Xor(left As LimitedInt, right As LimitedInt) As LimitedInt
        Return CType(left.Value Xor right.Value, LimitedInt)
    End Operator

    Shared Operator Not(left As LimitedInt) As LimitedInt
        Return CType(Not left.Value, LimitedInt)
    End Operator

    Shared Operator >>(left As LimitedInt, right As Integer) As LimitedInt
        Return CType(left.Value >> right, LimitedInt)
    End Operator

    Shared Operator <<(left As LimitedInt, right As Integer) As LimitedInt
        Return CType(left.Value << right, LimitedInt)
    End Operator

    Shared Widening Operator CType(value As LimitedInt) As Integer
        Return value.Value
    End Operator

    Shared Narrowing Operator CType(value As Integer) As LimitedInt
        If Not IsValidValue(value) Then Throw New OverflowException()
        Return New LimitedInt(value)
    End Operator
#End Region

    'Function TryFormat(destination As Span(Of Char), ByRef charsWritten As Integer, Optional format As ReadOnlySpan(Of Char) = Nothing, Optional provider As IFormatProvider = Nothing) As Boolean
    '    Return Me.Value.TryFormat(destination, charsWritten, format, provider)
    'End Function

    Overrides Function GetHashCode() As Integer
        Return Me.Value.GetHashCode
    End Function

    Overrides Function Equals(obj As Object) As Boolean
        Return TypeOf obj Is LimitedInt AndAlso Me.Equals(DirectCast(obj, LimitedInt))
    End Function

    Overrides Function ToString() As String
        Return Me.Value.ToString()
    End Function

#Region "Shared Methods"
    'Shared Function TryParse(s As ReadOnlySpan(Of Char), ByRef result As Integer) As Boolean
    '    Return Integer.TryParse(s, result)
    'End Function

    'Shared Function TryParse(s As ReadOnlySpan(Of Char), style As Globalization.NumberStyles, provider As IFormatProvider, ByRef result As Integer) As Boolean
    '    Return Integer.TryParse(s, style, provider, result)
    'End Function

    Shared Function Parse(s As String, provider As IFormatProvider) As Integer
        Return Integer.Parse(s, provider)
    End Function

    Shared Function Parse(s As String, style As Globalization.NumberStyles, provider As IFormatProvider) As Integer
        Return Integer.Parse(s, style, provider)
    End Function

    Shared Function TryParse(s As String, style As Globalization.NumberStyles, provider As IFormatProvider, ByRef result As Integer) As Boolean
        Return Integer.TryParse(s, style, provider, result)
    End Function

    Shared Function Parse(s As String) As Integer
        Return Integer.Parse(s)
    End Function
    Shared Function Parse(s As String, style As Globalization.NumberStyles) As Integer
        Return Integer.Parse(s, style)
    End Function

    'Shared Function Parse(s As ReadOnlySpan(Of Char), Optional style As Globalization.NumberStyles = Globalization.NumberStyles.Integer, Optional provider As IFormatProvider = Nothing) As Integer
    '    Return Integer.Parse(s, style, provider)
    'End Function

    Shared Function TryParse(s As String, ByRef result As Integer) As Boolean
        Return Integer.TryParse(s, result)
    End Function
#End Region
End Structure
