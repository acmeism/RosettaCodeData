template <typename T>
void insert_after(Node<T>* N, T&& data)
{
    auto node = new Node<T>{N, N->next, std::forward(data)};
    if(N->next != nullptr)
        N->next->prev = node;
    N->next = node;
}
