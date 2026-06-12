struct ListNode {
      int val;
      ListNode *next;
      ListNode(int x) : val(x), next(NULL) {}
 };

ListNode* Solution::detectCycle(ListNode* A) {
    ListNode* slow = A;
    ListNode* fast = A;
    ListNode* cycleNode = 0;
    while (slow && fast && fast->next)
    {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast)
        {
            cycleNode = slow;
            break;
        }
    }
    if (cycleNode == 0)
    {
        return 0;
    }
    std::set<ListNode*> setPerimeter;
    setPerimeter.insert(cycleNode);
    for (ListNode* pNode = cycleNode->next; pNode != cycleNode; pNode = pNode->next)
    setPerimeter.insert(pNode);
    for (ListNode* pNode = A; true; pNode = pNode->next)
    {
        std::set<ListNode*>::iterator iter = setPerimeter.find(pNode);
        if (iter != setPerimeter.end())
        {
            return pNode;
        }
    }
}
