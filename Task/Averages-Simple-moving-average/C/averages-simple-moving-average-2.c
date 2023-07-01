double v[] = { 1, 2, 3, 4, 5, 5, 4, 3, 2, 1 };

int main()
{
  int i;

  sma_obj_t *h3 = sma(SMA_NEW, 3).handle;
  sma_obj_t *h5 = sma(SMA_NEW, 5).handle;

  for(i=0; i < sizeof(v)/sizeof(double) ; i++) {
    printf("next number %lf, SMA_3 = %lf, SMA_5 = %lf\n",
	   v[i], sma(SMA_ADD, h3, v[i]).sma, sma(SMA_ADD, h5, v[i]).sma);
  }

  sma(SMA_FREE, h3);
  sma(SMA_FREE, h5);
  return 0;
}
