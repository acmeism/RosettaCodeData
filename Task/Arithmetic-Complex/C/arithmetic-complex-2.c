typedef struct{
        double real;
        double imag;
} Complex;

Complex add(Complex a, Complex b){
        Complex ans;
        ans.real = a.real + b.real;
        ans.imag = a.imag + b.imag;
        return ans;
}

Complex mult(Complex a, Complex b){
        Complex ans;
        ans.real = a.real * b.real - a.imag * b.imag;
        ans.imag = a.real * b.imag + a.imag * b.real;
        return ans;
}

/* it's arguable that things could be better handled if either
   a.real or a.imag is +/-inf, but that's much work */
Complex inv(Complex a){
        Complex ans;
        double denom = a.real * a.real + a.imag * a.imag;
        ans.real =  a.real / denom;
        ans.imag = -a.imag / denom;
        return ans;
}

Complex neg(Complex a){
        Complex ans;
        ans.real = -a.real;
        ans.imag = -a.imag;
        return ans;
}

Complex conj(Complex a){
        Complex ans;
        ans.real =  a.real;
        ans.imag = -a.imag;
        return ans;
}

void put(Complex c)
{
        printf("%lf%+lfI", c.real, c.imag);
}

void complex_ops(void)
{
  Complex a = { 1.0,     1.0 };
  Complex b = { 3.14159, 1.2 };

  printf("\na=");   put(a);
  printf("\nb=");   put(b);
  printf("\na+b="); put(add(a,b));
  printf("\na*b="); put(mult(a,b));
  printf("\n1/a="); put(inv(a));
  printf("\n-a=");  put(neg(a));
  printf("\nconj a=");  put(conj(a));  printf("\n");
}
