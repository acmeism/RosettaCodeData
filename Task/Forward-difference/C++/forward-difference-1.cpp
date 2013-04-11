#include <vector>
#include <iterator>
#include <algorithm>

// calculate first order forward difference
// requires:
// * InputIterator is an input iterator
// * OutputIterator is an output iterator
// * The value type of InputIterator is copy-constructible and assignable
// * The value type of InputIterator supports operator -
// * The result type of operator- is assignable to the value_type of OutputIterator
// returns: The iterator following the output sequence
template<typename InputIterator, typename OutputIterator>
 OutputIterator forward_difference(InputIterator first, InputIterator last,
                                   OutputIterator dest)
{
  // special case: for empty sequence, do nothing
  if (first == last)
    return dest;

  typedef typename std::iterator_traits<InputIterator>::value_type value_type;

  value_type temp = *first++;
  while (first != last)
  {
    value_type temp2 = *first++;
    *dest++ = temp2 - temp;
    temp = temp2;
  }

  return dest;
}

// calculate n-th order forward difference.
// requires:
// * InputIterator is an input iterator
// * OutputIterator is an output iterator
// * The value type of InputIterator is copy-constructible and assignable
// * The value type of InputIterator supports operator -
// * The result type of operator- is assignable to the value_type of InputIterator
// * The result type of operator- is assignable to the value_type of OutputIterator
// * order >= 0
// returns: The iterator following the output sequence
template<typename InputIterator, typename OutputIterator>
 OutputIterator nth_forward_difference(int order,
                                       InputIterator first, InputIterator last,
                                       OutputIterator dest)
{
  // special case: If order == 0, just copy input to output
  if (order == 0)
    return std::copy(first, last, dest);

  // second special case: If order == 1, just forward to the first-order function
  if (order == 1)
    return forward_difference(first, last, dest);

  // intermediate results are stored in a vector
  typedef typename std::iterator_traits<InputIterator>::value_type value_type;
  std::vector<value_type> temp_storage;

  // fill the vector with the result of the first order forward difference
  forward_difference(first, last, std::back_inserter(temp_storage));

  // the next n-2 iterations work directly on the vector
  typename std::vector<value_type>::iterator begin = temp_storage.begin(),
                                             end = temp_storage.end();
  for (int i = 1; i < order-1; ++i)
    end = forward_difference(begin, end, begin);

  // the final iteration writes directly to the output iterator
  return forward_difference(begin, end, dest);
}

// example usage code
#include <iostream>

int main()
{
  double array[10] = { 90.0, 47.0, 58.0, 29.0, 22.0, 32.0, 55.0, 5.0, 55.0, 73.0 };

  // this stores the results in the vector dest
  std::vector<double> dest;
  nth_forward_difference(1, array, array+10, std::back_inserter(dest));

  // outut dest
  std::copy(dest.begin(), dest.end(), std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

  // however, the results can also be output as they are calculated
  nth_forward_difference(2, array, array+10, std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

  nth_forward_difference(9, array, array+10, std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

  nth_forward_difference(10, array, array+10, std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

  nth_forward_difference(0, array, array+10, std::ostream_iterator<double>(std::cout, " "));
  std::cout << std::endl;

  // finally, the results can also be written into the original array
  // (which of course destroys the original content)
  double* end = nth_forward_difference(3, array, array+10, array);

  for (double* p = array; p < end; ++p)
    std::cout << *p << " ";
  std::cout << std::endl;

  return 0;
}
