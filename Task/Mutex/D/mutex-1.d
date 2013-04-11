class Synced
{
public:
    synchronized int func (int input)
    {
        num += input;
        return num;
    }
private:
    static num = 0;
}
