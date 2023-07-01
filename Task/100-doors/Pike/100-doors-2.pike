array doors = map(enumerate(100,1,1), lambda(int x)
                                      {
                                          return sqrt((float)x)%1 == 0.0;
                                      });
