package {

    import flash.display.GraphicsPathCommand;
    import flash.display.Sprite;

    /**
     * A Sierpinski triangle.
     */
    public class SierpinskiTriangle extends Sprite {

        /**
         * Creates a new SierpinskiTriangle object.
         *
         * @param n The order of the Sierpinski triangle.
         * @param c1 The background colour.
         * @param c2 The foreground colour.
         * @param width The width of the triangle.
         * @param height The height of the triangle.
         */
        public function SierpinskiTriangle(n:uint, c1:uint, c2:uint, width:Number, height:Number):void {
            _init(n, c1, c2, width, height);
        }

        /**
         * Generates the triangle.
         *
         * @param n The order of the Sierpinski triangle.
         * @param c1 The background colour.
         * @param c2 The foreground colour.
         * @param width The width of the triangle.
         * @param height The height of the triangle.
         * @private
         */
        private function _init(n:uint, c1:uint, c2:uint, width:Number, height:Number):void {

            if ( n <= 0 )
                return;

            // Draw the outer triangle.

            graphics.beginFill(c1);
            graphics.moveTo(width / 2, 0);
            graphics.lineTo(0, height);
            graphics.lineTo(width, height);
            graphics.lineTo(width / 2, 0);

            // Draw the inner triangle.

            graphics.beginFill(c2);
            graphics.moveTo(width / 4, height / 2);
            graphics.lineTo(width * 3 / 4, height / 2);
            graphics.lineTo(width / 2, height);
            graphics.lineTo(width / 4, height / 2);

            if ( n == 1 )
                return;

            // Recursively generate three Sierpinski triangles of half the size and order n - 1 and position them appropriately.

            var sub1:SierpinskiTriangle = new SierpinskiTriangle(n - 1, c1, c2, width / 2, height / 2);
            var sub2:SierpinskiTriangle = new SierpinskiTriangle(n - 1, c1, c2, width / 2, height / 2);
            var sub3:SierpinskiTriangle = new SierpinskiTriangle(n - 1, c1, c2, width / 2, height / 2);

            sub1.x = width / 4;
            sub1.y = 0;
            sub2.x = 0;
            sub2.y = height / 2;
            sub3.x = width / 2;
            sub3.y = height / 2;

            addChild(sub1);
            addChild(sub2);
            addChild(sub3);

        }

    }

}
