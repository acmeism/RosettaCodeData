void step_up(void)
{
    int i = 0;

    while (i < 1) {
        if (step()) {
            ++i;
        } else {
            --i;
        }
    }
}
