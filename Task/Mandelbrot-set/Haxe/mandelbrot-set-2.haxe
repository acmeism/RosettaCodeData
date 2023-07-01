class Mandelbrot extends flash.display.Sprite
{
    inline static var MAX_ITER = 255;

    public static function main() {
        var w = flash.Lib.current.stage.stageWidth;
        var h = flash.Lib.current.stage.stageHeight;
        var mandelbrot = new Mandelbrot(w, h);
        flash.Lib.current.stage.addChild(mandelbrot);
        mandelbrot.drawMandelbrot();
    }

    var image:flash.display.BitmapData;
    public function new(width, height) {
        super();
        var bitmap:flash.display.Bitmap;
        image = new flash.display.BitmapData(width, height, false);
        bitmap = new flash.display.Bitmap(image);
        this.addChild(bitmap);
    }

    public function drawMandelbrot() {
        image.lock();
        var step_x = 3.0 / (image.width-1);
        var step_y = 2.0 / (image.height-1);
        for (i in 0...image.height) {
            var ci = i * step_y - 1.0;
            for (j in 0...image.width) {
                var k = 0;
                var zr = 0.0;
                var zi = 0.0;
                var cr = j * step_x - 2.0;
                while (k <= MAX_ITER && (zr*zr + zi*zi) <= 4) {
                    var temp = zr*zr - zi*zi + cr;
                    zi = 2*zr*zi + ci;
                    zr = temp;
                    k ++;
                }
                paint(j, i, k);
            }
        }
        image.unlock();
    }

    inline function paint(x, y, iter) {
        var color = iter > MAX_ITER? 0 : iter * 0x100;
        image.setPixel(x, y, color);
    }
}
