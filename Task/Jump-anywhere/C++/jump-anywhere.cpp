#include <iostream>
#include <utility>

using namespace std;

int main(void)
{
    cout << "Find a solution to i = 2 * j - 7\n";
    pair<int, int> answer;
    for(int i = 0; true; i++)
    {
        for(int j = 0; j < i; j++)
        {
            if( i == 2 * j - 7)
            {
                // use brute force and run until a solution is found
                answer = make_pair(i, j);
                goto loopexit;
            }
        }
    }

loopexit:
    cout << answer.first << " = 2 * " << answer.second << " - 7\n\n";

    // jumping out of nested loops is the main usage of goto in
    // C++.  goto can be used in other places but there is usually
    // a better construct.  goto is not allowed to jump across
    // initialized variables which limits where it can be used.
    // this is case where C++ is more restrictive than C.

    goto spagetti;

    int k;
    k = 9;  // this is assignment, can be jumped over

    /* The line below won't compile because a goto is not allowed
     * to jump over an initialized value.
    int j = 9;
    */

spagetti:

    cout << "k = " << k << "\n";  // k was never initialized, accessing it is undefined behavior

}
