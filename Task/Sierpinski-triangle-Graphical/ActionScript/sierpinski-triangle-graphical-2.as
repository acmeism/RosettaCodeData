package {
	
    import flash.display.Sprite;
    import flash.events.Event;

    public class Main extends Sprite {

        public function Main():void {
            if ( stage ) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event = null):void {
            var s:SierpinskiTriangle = new SierpinskiTriangle(5, 0x0000FF, 0xFFFF00, 300, 150 * Math.sqrt(3));
            // Equilateral triangle (blue and yellow)
            s.x = s.y = 20;
            addChild(s);
        }

    }

}
