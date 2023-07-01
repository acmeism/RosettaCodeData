@interface Tree<T> : NSObject {
  T value;
  Tree<T> *left;
  Tree<T> *right;
}

- (void)replaceAll:(T)v;
@end

@implementation Tree
- (void)replaceAll:(id)v {
  value = v;
  [left replaceAll:v];
  [right replaceAll:v];
}
@end
