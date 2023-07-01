-(long)fibonacci:(int)position
{
    long result = 0;
    if (position < 2) {
        result = position;
    } else {
        result = [self fibonacci:(position -1)] + [self fibonacci:(position -2)];
    }
    return result;
}
