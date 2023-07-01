/* test */
double f3(double x)
{
  return x;
}

double f3a(double x)
{
  return x*x/2.0;
}

double f2(double x)
{
  return 1.0/x;
}

double f2a(double x)
{
  return log(x);
}

double f1(double x)
{
  return x*x*x;
}

double f1a(double x)
{
  return x*x*x*x/4.0;
}

typedef double (*pfunc)(double, double, double, double (*)());
typedef double (*rfunc)(double);

#define INTG(F,A,B) (F((B))-F((A)))

int main()
{
     int i, j;
     double ic;

     pfunc f[5] = {
       int_leftrect, int_rightrect,
       int_midrect,  int_trapezium,
       int_simpson
     };
     const char *names[5] = {
       "leftrect", "rightrect", "midrect",
       "trapezium", "simpson"
     };
     rfunc rf[] = { f1, f2, f3, f3 };
     rfunc If[] = { f1a, f2a, f3a, f3a };
     double ivals[] = {
       0.0, 1.0,
       1.0, 100.0,
       0.0, 5000.0,
       0.0, 6000.0
     };
     double approx[] = { 100.0, 1000.0, 5000000.0, 6000000.0 };

     for(j=0; j < (sizeof(rf) / sizeof(rfunc)); j++)
     {
       for(i=0; i < 5 ; i++)
       {
         ic = (*f[i])(ivals[2*j], ivals[2*j+1], approx[j], rf[j]);
         printf("%10s [ 0,1] num: %+lf, an: %lf\n",
                names[i], ic, INTG((*If[j]), ivals[2*j], ivals[2*j+1]));
       }
       printf("\n");
     }
}
