#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

typedef struct sma_obj {
  double sma;
  double sum;
  int period;
  double *values;
  int lv;
} sma_obj_t;

typedef union sma_result {
  sma_obj_t *handle;
  double sma;
  double *values;
} sma_result_t;

enum Action { SMA_NEW, SMA_FREE, SMA_VALUES, SMA_ADD, SMA_MEAN };
sma_result_t sma(enum Action action, ...)
{
  va_list vl;
  sma_result_t r;
  sma_obj_t *o;
  double v;

  va_start(vl, action);
  switch(action) {
  case SMA_NEW: // args: int period
    r.handle = malloc(sizeof(sma_obj_t));
    r.handle->sma = 0.0;
    r.handle->period = va_arg(vl, int);
    r.handle->values = malloc(r.handle->period * sizeof(double));
    r.handle->lv = 0;
    r.handle->sum = 0.0;
    break;
  case SMA_FREE: // args: sma_obj_t *handle
    r.handle = va_arg(vl, sma_obj_t *);
    free(r.handle->values);
    free(r.handle);
    r.handle = NULL;
    break;
  case SMA_VALUES: // args: sma_obj_t *handle
    o = va_arg(vl, sma_obj_t *);
    r.values = o->values;
    break;
  case SMA_MEAN: // args: sma_obj_t *handle
    o = va_arg(vl, sma_obj_t *);
    r.sma = o->sma;
    break;
  case SMA_ADD: // args: sma_obj_t *handle, double value
    o = va_arg(vl, sma_obj_t *);
    v = va_arg(vl, double);
    if ( o->lv < o->period ) {
      o->values[o->lv++] = v;
      o->sum += v;
      o->sma = o->sum / o->lv;
    } else {
      o->sum -= o->values[ o->lv % o->period];
      o->sum += v;
      o->sma = o->sum / o->period;
      o->values[ o->lv % o->period ] = v; o->lv++;
    }
    r.sma = o->sma;
    break;
  }
  va_end(vl);
  return r;
}
