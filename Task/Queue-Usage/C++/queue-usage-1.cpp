#include <queue>
#include <cassert> // for run time assertions

int main()
{
  std::queue<int> q;
  assert( q.empty() );        // initially the queue is empty

  q.push(1);                  // add an element
  assert( !q.empty() );       // now the queue isn't empty any more
  assert( q.front() == 1 );   // the first element is, of course, 1

  q.push(2);                  // add another element
  assert( !q.empty() );       // it's of course not empty again
  assert( q.front() == 1 );   // the first element didn't change

  q.push(3);                  // add yet an other element
  assert( !q.empty() );       // the queue is still not empty
  assert( q.front() == 1 );   // and the first element is still 1

  q.pop();                    // remove the first element
  assert( !q.empty() );       // the queue is not yet empty
  assert( q.front() == 2);    // the first element is now 2 (the 1 is gone)

  q.pop();
  assert( !q.empty() );
  assert( q.front() == 3);

  q.push(4);
  assert( !q.empty() );
  assert( q.front() == 3);

  q.pop();
  assert( !q.empty() );
  assert( q.front() == 4);

  q.pop();
  assert( q.empty() );

  q.push(5);
  assert( !q.empty() );
  assert( q.front() == 5);

  q.pop();
  assert( q.empty() );
}
