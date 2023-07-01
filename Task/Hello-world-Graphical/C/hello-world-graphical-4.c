#include <conio.h>
#include <graphics.h>

int main(void) {
    int Driver = DETECT, Mode;
    int MaxX, MaxY, X, Y;
    char Message[] = "Hello, World!";

    initgraph(&Driver, &Mode, "");

    MaxX = getmaxx();
    MaxY = getmaxy();

    settextstyle(SANS_SERIF_FONT, HORIZ_DIR, 7);

    X = (MaxX - textwidth(Message)) >> 1;
    Y = (MaxY - textheight(Message)) >> 1;
    outtextxy(X, Y, Message);

    getch();
    closegraph();
    return 0;
}
