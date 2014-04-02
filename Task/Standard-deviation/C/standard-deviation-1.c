#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef enum Action { STDDEV, MEAN, VAR, COUNT } Action;

typedef struct stat_obj_struct {
   double sum, sum2;
   size_t num;
   Action action;
} sStatObject, *StatObject;

StatObject NewStatObject( Action action )
{
  StatObject so;

  so = malloc(sizeof(sStatObject));
  so->sum = 0.0;
  so->sum2 = 0.0;
  so->num = 0;
  so->action = action;
  return so;
}
#define FREE_STAT_OBJECT(so) \
   free(so); so = NULL
double stat_obj_value(StatObject so, Action action)
{
  double num, mean, var, stddev;

  if (so->num == 0.0) return 0.0;
  num = so->num;
  if (action==COUNT) return num;
  mean = so->sum/num;
  if (action==MEAN) return mean;
  var = so->sum2/num - mean*mean;
  if (action==VAR) return var;
  stddev = sqrt(var);
  if (action==STDDEV) return stddev;
  return 0;
}

double stat_object_add(StatObject so, double v)
{
  so->num++;
  so->sum += v;
  so->sum2 += v*v;
  return stat_obj_value(so, so->action);
}
