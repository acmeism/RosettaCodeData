@implementation AVLTree

-(BOOL)insertWithKey:(NSInteger)key {

    if (self.root == nil) {
        self.root = [[AVLTreeNode alloc]initWithKey:key andParent:nil];
    } else {

        AVLTreeNode *n = self.root;
        AVLTreeNode *parent;

        while (true) {

            if (n.key == key) {
                return false;
            }

            parent = n;

            BOOL goLeft = n.key > key;
            n = goLeft ? n.left : n.right;

            if (n == nil) {

                if (goLeft) {
                    parent.left = [[AVLTreeNode alloc]initWithKey:key andParent:parent];
                } else {
                    parent.right = [[AVLTreeNode alloc]initWithKey:key andParent:parent];
                }
                [self rebalanceStartingAtNode:parent];
                break;
            }
        }
    }

    return true;
}

-(void)rebalanceStartingAtNode:(AVLTreeNode*)n {

    [self setBalance:@[n]];

    if (n.balance == -2) {
        if ([self height:(n.left.left)] >= [self height:n.left.right]) {
            n = [self rotateRight:n];
        } else {
            n = [self rotateLeftThenRight:n];
        }
    } else if (n.balance == 2) {
        if ([self height:n.right.right] >= [self height:n.right.left]) {
            n = [self rotateLeft:n];
        } else {
            n = [self rotateRightThenLeft:n];
        }
    }

    if (n.parent != nil) {
        [self rebalanceStartingAtNode:n.parent];
    } else {
        self.root = n;
    }
}


-(AVLTreeNode*)rotateRight:(AVLTreeNode*)a {

    AVLTreeNode *b = a.left;
    b.parent = a.parent;

    a.left = b.right;

    if (a.left != nil) {
        a.left.parent = a;
    }

    b.right = a;
    a.parent = b;

    if (b.parent != nil) {
        if (b.parent.right == a) {
            b.parent.right = b;
        } else {
            b.parent.left = b;
        }
    }

    [self setBalance:@[a,b]];
    return b;

}

-(AVLTreeNode*)rotateLeftThenRight:(AVLTreeNode*)n {

    n.left = [self rotateLeft:n.left];
    return [self rotateRight:n];

}

-(AVLTreeNode*)rotateRightThenLeft:(AVLTreeNode*)n {

    n.right = [self rotateRight:n.right];
    return [self rotateLeft:n];
}

-(AVLTreeNode*)rotateLeft:(AVLTreeNode*)a {

    //set a's right node as b
    AVLTreeNode* b = a.right;
    //set b's parent as a's parent (which could be nil)
    b.parent = a.parent;
    //in case b had a left child transfer it to a
    a.right = b.left;

    // after changing a's reference to the right child, make sure the parent is set too
    if (a.right != nil) {
        a.right.parent = a;
    }

    // switch a over to the left to be b's left child
    b.left = a;
    a.parent = b;

    if (b.parent != nil) {
        if (b.parent.right == a) {
            b.parent.right = b;
        } else {
            b.parent.right = b;
        }
    }

    [self setBalance:@[a,b]];

    return b;

}



-(void) setBalance:(NSArray*)nodesArray {

    for (AVLTreeNode* n in nodesArray) {

        n.balance = [self height:n.right] - [self height:n.left];
    }

}

-(int)height:(AVLTreeNode*)n {

    if (n == nil) {
        return -1;
    }

    return 1 + MAX([self height:n.left], [self height:n.right]);
}

-(void)printKey:(AVLTreeNode*)n {
    if (n != nil) {
        [self printKey:n.left];
        NSLog(@"%ld", n.key);
        [self printKey:n.right];
    }
}

-(void)printBalance:(AVLTreeNode*)n {
    if (n != nil) {
        [self printBalance:n.left];
        NSLog(@"%ld", n.balance);
        [self printBalance:n.right];
    }
}
@end
-- test

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        AVLTree *tree = [AVLTree new];
        NSLog(@"inserting values 1 to 6");
        [tree insertWithKey:1];
        [tree insertWithKey:2];
        [tree insertWithKey:3];
        [tree insertWithKey:4];
        [tree insertWithKey:5];
        [tree insertWithKey:6];

        NSLog(@"printing balance: ");
        [tree printBalance:tree.root];

        NSLog(@"printing key: ");
        [tree printKey:tree.root];
    }
    return 0;
}
