package {
    public class Circle extends Point
    {
        private var r:Number;

        public function Circle(x:Number=0, y:Number=0, r:Number=0)
        {
            super(x, y);
            this.r = r;
        }

        public function getR():Number
        {
            return r;
        }

        public function setR(r:Number):void
        {
            this.r = r;
        }

        public override function print():void
        {
            trace("Circle");
        }
    }
}
