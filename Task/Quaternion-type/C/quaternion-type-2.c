int main()
{
  size_t i;
  double d = 7.0;
  quaternion_t *q[3];
  quaternion_t *r  = quaternion_new();

  quaternion_t *qd = quaternion_new_set(7.0, 0.0, 0.0, 0.0);
  q[0] = quaternion_new_set(1.0, 2.0, 3.0, 4.0);
  q[1] = quaternion_new_set(2.0, 3.0, 4.0, 5.0);
  q[2] = quaternion_new_set(3.0, 4.0, 5.0, 6.0);

  printf("r = %lf\n", d);

  for(i = 0; i < 3; i++) {
    printf("q[%u] = ", i);
    quaternion_print(q[i]);
    printf("abs q[%u] = %lf\n", i, quaternion_norm(q[i]));
  }

  printf("-q[0] = ");
  quaternion_neg(r, q[0]);
  quaternion_print(r);

  printf("conj q[0] = ");
  quaternion_conj(r, q[0]);
  quaternion_print(r);

  printf("q[1] + q[2] = ");
  quaternion_add(r, q[1], q[2]);
  quaternion_print(r);

  printf("q[2] + q[1] = ");
  quaternion_add(r, q[2], q[1]);
  quaternion_print(r);


  printf("q[0] * r = ");
  quaternion_mul_d(r, q[0], d);
  quaternion_print(r);

  printf("q[0] * (r, 0, 0, 0) = ");
  quaternion_mul(r, q[0], qd);
  quaternion_print(r);


  printf("q[1] * q[2] = ");
  quaternion_mul(r, q[1], q[2]);
  quaternion_print(r);

  printf("q[2] * q[1] = ");
  quaternion_mul(r, q[2], q[1]);
  quaternion_print(r);


  free(q[0]); free(q[1]); free(q[2]); free(r);
  return EXIT_SUCCESS;
}
