void step_up(void)
{
    while (!step()) {
        step_up();
    }
}
