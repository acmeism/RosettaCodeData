array onehundreddoors()
{
    array doors = allocate(100);
    foreach(doors; int i;)
        for(int j=i; j<100; j+=i+1)
            doors[j] = !doors[j];
    return doors;
}
