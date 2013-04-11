import dfl.all;
import std.math;

class FractalTree: Form {

    private const double DEG_TO_RAD = PI / 180.0;

    this() {
        width = 600;
        height = 500;
        text = "Fractal Tree";
        backColor = Color(0xFF, 0xFF, 0xFF);
        startPosition = FormStartPosition.CENTER_SCREEN;
        formBorderStyle = FormBorderStyle.FIXED_DIALOG;
        maximizeBox = false;
    }

    private void drawTree(Graphics g, Pen p, int x1, int y1, double angle, int depth) {
        if (depth == 0) return;
        int x2 = x1 + cast(int) (cos(angle * DEG_TO_RAD) * depth * 10.0);
        int y2 = y1 + cast(int) (sin(angle * DEG_TO_RAD) * depth * 10.0);
        g.drawLine(p, x1, y1, x2, y2);
        drawTree(g, p, x2, y2, angle - 20, depth - 1);
        drawTree(g, p, x2, y2, angle + 20, depth - 1);
    }

    protected override void onPaint(PaintEventArgs ea){
        super.onPaint(ea);
        Pen p = new Pen(Color(0, 0xAA, 0));
        drawTree(ea.graphics, p, 300, 450, -90, 9);
    }
}

int main() {
    int result = 0;
    try {
        Application.run(new FractalTree);
    } catch(Object o) {
        msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
        result = 1;
    }
    return result;
}
