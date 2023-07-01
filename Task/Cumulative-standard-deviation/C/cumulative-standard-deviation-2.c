double v[] = { 2,4,4,4,5,5,7,9 };

int main()
{
  int i;
  StatObject so = NewStatObject( STDDEV );

  for(i=0; i < sizeof(v)/sizeof(double) ; i++)
    printf("val: %lf  std dev: %lf\n", v[i], stat_object_add(so, v[i]));

  FREE_STAT_OBJECT(so);
  return 0;
}
