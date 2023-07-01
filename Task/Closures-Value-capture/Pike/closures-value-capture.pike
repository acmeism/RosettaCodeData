array funcs = ({});
foreach(enumerate(10);; int i)
{
  funcs+= ({
              lambda(int j)
              {
                  return lambda()
                         {
                             return j*j;
                         };
              }(i)
          });
}
