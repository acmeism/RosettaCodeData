using System;

struct Quaternion : IEquatable<Quaternion>
{
    public readonly double A, B, C, D;

    public Quaternion(double a, double b, double c, double d)
    {
        this.A = a;
        this.B = b;
        this.C = c;
        this.D = d;
    }

    public double Norm()
    {
        return Math.Sqrt(A * A + B * B + C * C + D * D);
    }

    public static Quaternion operator -(Quaternion q)
    {
        return new Quaternion(-q.A, -q.B, -q.C, -q.D);
    }

    public Quaternion Conjugate()
    {
        return new Quaternion(A, -B, -C, -D);
    }

    // implicit conversion takes care of real*quaternion and real+quaternion
    public static implicit operator Quaternion(double d)
    {
        return new Quaternion(d, 0, 0, 0);
    }

    public static Quaternion operator +(Quaternion q1, Quaternion q2)
    {
        return new Quaternion(q1.A + q2.A, q1.B + q2.B, q1.C + q2.C, q1.D + q2.D);
    }

    public static Quaternion operator *(Quaternion q1, Quaternion q2)
    {
        return new Quaternion(
            q1.A * q2.A - q1.B * q2.B - q1.C * q2.C - q1.D * q2.D,
            q1.A * q2.B + q1.B * q2.A + q1.C * q2.D - q1.D * q2.C,
            q1.A * q2.C - q1.B * q2.D + q1.C * q2.A + q1.D * q2.B,
            q1.A * q2.D + q1.B * q2.C - q1.C * q2.B + q1.D * q2.A);
    }

    public static bool operator ==(Quaternion q1, Quaternion q2)
    {
        return q1.A == q2.A && q1.B == q2.B && q1.C == q2.C && q1.D == q2.D;
    }

    public static bool operator !=(Quaternion q1, Quaternion q2)
    {
        return !(q1 == q2);
    }

    #region Object Members

    public override bool Equals(object obj)
    {
        if (obj is Quaternion)
            return Equals((Quaternion)obj);

        return false;
    }

    public override int GetHashCode()
    {
        return A.GetHashCode() ^ B.GetHashCode() ^ C.GetHashCode() ^ D.GetHashCode();
    }

    public override string ToString()
    {
        return string.Format("Q({0}, {1}, {2}, {3})", A, B, C, D);
    }

    #endregion

    #region IEquatable<Quaternion> Members

    public bool Equals(Quaternion other)
    {
        return other == this;
    }

    #endregion
}
