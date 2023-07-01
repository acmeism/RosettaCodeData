main()
{
        int a = 0;

        do {
                register int _o = 2;
                do {
                        switch (_o) {
                        case 1:
                                a = 4;
                        case 0:
                                break;
                        case 2:
                                _o = !!(foo());
                                continue;
                        } break;
                } while (1);
        } while (0);
        printf("%d\n", a);
        exit(0);
}
