package
{
    public class Point
    {
        protected var _x:Number;
        protected var _y:Number;

        public function Point(x:Number = 0, y:Number = 0)
        {
            _x = x;
            _y = y;
        }

        public function getX():Number
        {
            return _x;
        }

        public function setX(x:Number):void
        {
            _x = x;
        }

        public function getY():Number
        {
            return _y;
        }

        public function setY(y:Number):void
        {
            _x = y;
        }

        public function print():void
        {
            trace("Point");
        }
    }
}
