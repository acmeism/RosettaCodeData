#include <iostream>

using namespace std;

const int MAX_DIM = 16;

typedef int* tree;

int left(int index)
{
    return index*2+1;
}

int right(int index)
{
    return index*2+2;
}

void preorder(tree t, int index = 0)
{
    if(index < MAX_DIM && t[index] != 0){
        cout << t[index] << ' ';
        preorder(t, left(index));
        preorder(t, right(index));
    }
}

void inorder(tree t, int index = 0)
{
    if(index < MAX_DIM && t[index] != 0){
        inorder(t, left(index));
        cout << t[index] << ' ';
        inorder(t, right(index));
    }
}

void postorder(tree t, int index = 0)
{
    if(index < MAX_DIM && t[index] != 0){
        postorder(t, left(index));
        postorder(t, right(index));
        cout << t[index] << ' ';
    }
}

void level_order(tree t, int index = 0)
{
    for(int i = 0; i < MAX_DIM; ++i){
        if(t[i] != 0)
            cout << t[i] << ' ';
    }
}

int main()
{
    int t[MAX_DIM] = {1,2,3,4,5,6,0,7,0,0,0,8,9};
    cout << "preorder: ";
    preorder(t);
    cout << endl;
    cout << "inorder: ";
    inorder(t);
    cout << endl;
    cout << "postorder: ";
    postorder(t);
    cout << endl;
    cout << "level_order: ";
    level_order(t);
    cout << endl;
}
