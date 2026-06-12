#define MY_NEW_FEATURE_ENABLED

...

#ifdef MY_NEW_FEATURE_ENABLED
  my_new_feature();
#endif

...

#ifdef MY_NEW_FEATURE_ENABLED
  close_my_new_feature();
#endif
