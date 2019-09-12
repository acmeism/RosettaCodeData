public class Line
    {
        private double x0, y0, x1, y1;
        private Color foreColor;
        private byte lineStyleMask;
        private int thickness;
        private float globalm;

        public Line(double x0, double y0, double x1, double y1, Color color, byte lineStyleMask, int thickness)
        {
            this.x0 = x0;
            this.y0 = y0;
            this.y1 = y1;
            this.x1 = x1;

            this.foreColor = color;

            this.lineStyleMask = lineStyleMask;

            this.thickness = thickness;

        }

        private void plot(Bitmap bitmap, double x, double y, double c)
        {
            int alpha = (int)(c * 255);
            if (alpha > 255) alpha = 255;
            if (alpha < 0) alpha = 0;
            Color color = Color.FromArgb(alpha, foreColor);
            if (BitmapDrawHelper.checkIfInside((int)x, (int)y, bitmap))
            {
                bitmap.SetPixel((int)x, (int)y, color);
            }
        }

        int ipart(double x) { return (int)x;}

        int round(double x) {return ipart(x+0.5);}

        double fpart(double x) {
            if(x<0) return (1-(x-Math.Floor(x)));
            return (x-Math.Floor(x));
        }

        double rfpart(double x) {
            return 1-fpart(x);
        }


        public void draw(Bitmap bitmap) {
            bool steep = Math.Abs(y1-y0)>Math.Abs(x1-x0);
             double temp;
            if(steep){
                temp=x0; x0=y0; y0=temp;
                temp=x1;x1=y1;y1=temp;
            }
            if(x0>x1){
                temp = x0;x0=x1;x1=temp;
                temp = y0;y0=y1;y1=temp;
            }

            double dx = x1-x0;
            double dy = y1-y0;
            double gradient = dy/dx;

            double xEnd = round(x0);
            double yEnd = y0+gradient*(xEnd-x0);
            double xGap = rfpart(x0+0.5);
            double xPixel1 = xEnd;
            double yPixel1 = ipart(yEnd);

            if(steep){
                plot(bitmap, yPixel1,   xPixel1, rfpart(yEnd)*xGap);
                plot(bitmap, yPixel1+1, xPixel1,  fpart(yEnd)*xGap);
            }else{
                plot(bitmap, xPixel1,yPixel1, rfpart(yEnd)*xGap);
                plot(bitmap, xPixel1, yPixel1+1, fpart(yEnd)*xGap);
            }
            double intery = yEnd+gradient;

            xEnd = round(x1);
            yEnd = y1+gradient*(xEnd-x1);
            xGap = fpart(x1+0.5);
            double xPixel2 = xEnd;
            double yPixel2 = ipart(yEnd);
            if(steep){
                plot(bitmap, yPixel2,   xPixel2, rfpart(yEnd)*xGap);
                plot(bitmap, yPixel2+1, xPixel2, fpart(yEnd)*xGap);
            }else{
                plot(bitmap, xPixel2, yPixel2, rfpart(yEnd)*xGap);
                plot(bitmap, xPixel2, yPixel2+1, fpart(yEnd)*xGap);
            }

            if(steep){
                for(int x=(int)(xPixel1+1);x<=xPixel2-1;x++){
                    plot(bitmap, ipart(intery), x, rfpart(intery));
                    plot(bitmap, ipart(intery)+1, x, fpart(intery));
                    intery+=gradient;
                }
            }else{
                for(int x=(int)(xPixel1+1);x<=xPixel2-1;x++){
                    plot(bitmap, x,ipart(intery), rfpart(intery));
                    plot(bitmap, x, ipart(intery)+1, fpart(intery));
                    intery+=gradient;
                }
            }
        }
    }
