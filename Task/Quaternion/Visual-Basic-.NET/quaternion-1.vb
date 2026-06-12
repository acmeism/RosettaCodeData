Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Structure Quaternion
    Implements IEquatable(Of Quaternion), IStructuralEquatable

    Public ReadOnly A, B, C, D As Double

    Public Sub New(a As Double, b As Double, c As Double, d As Double)
        Me.A = a
        Me.B = b
        Me.C = c
        Me.D = d
    End Sub

    Public ReadOnly Property Norm As Double
        Get
            Return Math.Sqrt((Me.A ^ 2) + (Me.B ^ 2) + (Me.C ^ 2) + (Me.D ^ 2))
        End Get
    End Property

    Public ReadOnly Property Conjugate As Quaternion
        Get
            Return New Quaternion(Me.A, -Me.B, -Me.C, -Me.D)
        End Get
    End Property

    Public Overrides Function Equals(obj As Object) As Boolean
        If TypeOf obj IsNot Quaternion Then Return False
        Return Me.Equals(DirectCast(obj, Quaternion))
    End Function

    Public Overloads Function Equals(other As Quaternion) As Boolean Implements IEquatable(Of Quaternion).Equals
        Return other = Me
    End Function

    Public Overloads Function Equals(other As Object, comparer As IEqualityComparer) As Boolean Implements IStructuralEquatable.Equals
        If TypeOf other IsNot Quaternion Then Return False
        Dim q = DirectCast(other, Quaternion)
        Return comparer.Equals(Me.A, q.A) AndAlso
               comparer.Equals(Me.B, q.B) AndAlso
               comparer.Equals(Me.C, q.C) AndAlso
               comparer.Equals(Me.D, q.D)
    End Function

    Public Overrides Function GetHashCode() As Integer
        Return HashCode.Combine(Me.A, Me.B, Me.C, Me.D)
    End Function

    Public Overloads Function GetHashCode(comparer As IEqualityComparer) As Integer Implements IStructuralEquatable.GetHashCode
        Return HashCode.Combine(
            comparer.GetHashCode(Me.A),
            comparer.GetHashCode(Me.B),
            comparer.GetHashCode(Me.C),
            comparer.GetHashCode(Me.D))
    End Function

    Public Overrides Function ToString() As String
        Return $"Q({Me.A}, {Me.B}, {Me.C}, {Me.D})"
    End Function

#Region "Operators"
    Public Shared Operator =(left As Quaternion, right As Quaternion) As Boolean
        Return left.A = right.A AndAlso
               left.B = right.B AndAlso
               left.C = right.C AndAlso
               left.D = right.D
    End Operator

    Public Shared Operator <>(left As Quaternion, right As Quaternion) As Boolean
        Return Not left = right
    End Operator

    Public Shared Operator +(q1 As Quaternion, q2 As Quaternion) As Quaternion
        Return New Quaternion(q1.A + q2.A, q1.B + q2.B, q1.C + q2.C, q1.D + q2.D)
    End Operator

    Public Shared Operator -(q As Quaternion) As Quaternion
        Return New Quaternion(-q.A, -q.B, -q.C, -q.D)
    End Operator

    Public Shared Operator *(q1 As Quaternion, q2 As Quaternion) As Quaternion
        Return New Quaternion(
            (q1.A * q2.A) - (q1.B * q2.B) - (q1.C * q2.C) - (q1.D * q2.D),
            (q1.A * q2.B) + (q1.B * q2.A) + (q1.C * q2.D) - (q1.D * q2.C),
            (q1.A * q2.C) - (q1.B * q2.D) + (q1.C * q2.A) + (q1.D * q2.B),
            (q1.A * q2.D) + (q1.B * q2.C) - (q1.C * q2.B) + (q1.D * q2.A))
    End Operator

    Public Shared Widening Operator CType(d As Double) As Quaternion
        Return New Quaternion(d, 0, 0, 0)
    End Operator
#End Region
End Structure
