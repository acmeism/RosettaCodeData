package  {

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class Clock extends Sprite {

        // Changes of hands (in degrees) per second
        private static const HOUR_HAND_CHANGE:Number = 1 / 120;  // 360 / (60 * 60 * 12)
        private static const MINUTE_HAND_CHANGE:Number = 0.1;      // 360 / (60 * 60)
        private static const SECOND_HAND_CHANGE:Number = 6;        // 360 / 60

        private var _timer:Timer;

        private var _hHand:Shape;
        private var _mHand:Shape;
        private var _sHand:Shape;

        public function Clock() {
            if ( stage ) _init();
            else addEventListener(Event.ADDED_TO_STAGE, _init);
        }

        private function _init(e:Event = null):void {

            var i:uint;

            var base:Shape = new Shape(), hHand:Shape = new Shape(), mHand:Shape = new Shape();
            var sHand:Shape = new Shape(), hub:Shape = new Shape();

            var size:Number = 500;
            var c:Number = size / 2;
            x = 30;
            y = 30;

            var baseGraphics:Graphics = base.graphics;

            baseGraphics.lineStyle(5, 0xEE0000);
            baseGraphics.beginFill(0xFFDDDD);
            baseGraphics.drawCircle(c, c, c);

            var uAngle:Number = Math.PI / 30;

            var markerStart:Number = c - 30;
            var markerEnd:Number = c - 15;

            var markerX1:Number, markerY1:Number, markerX2:Number, markerY2:Number;
            var angle:Number, angleSin:Number, angleCos:Number;

            baseGraphics.endFill();

            var isMajorMarker:Boolean = true;

            for ( i = 0; i < 60; i++ ) {
                // Draw the markers

                angle = uAngle * i;
                angleSin = Math.sin(angle);
                angleCos = Math.cos(angle);

                markerX1 = c + markerStart * angleCos;
                markerY1 = c + markerStart * angleSin;
                markerX2 = c + markerEnd * angleCos;
                markerY2 = c + markerEnd * angleSin;

                if ( i % 5 == 0 ) {
                    baseGraphics.lineStyle(3, 0x000080);
                    isMajorMarker = true;
                }
                else if ( isMajorMarker ) {
                    baseGraphics.lineStyle(1, 0x000080);
                    isMajorMarker = false;
                }

                baseGraphics.moveTo(markerX1, markerY1);
                baseGraphics.lineTo(markerX2, markerY2);
            }

            addChild(base);

            sHand.graphics.lineStyle(2, 0x00BB00);
            sHand.graphics.moveTo(0, 0);
            sHand.graphics.lineTo(0, 40 - c);
            sHand.x = sHand.y = c;

            mHand.graphics.lineStyle(8, 0x444444);
            mHand.graphics.moveTo(0, 0);
            mHand.graphics.lineTo(0, 50 - c);
            mHand.x = mHand.y = c;

            hHand.graphics.lineStyle(8, 0x777777);
            hHand.graphics.moveTo(0, 0);
            hHand.graphics.lineTo(0, 120 - c);
            hHand.x = hHand.y = c;

            hub.graphics.lineStyle(4, 0x664444);
            hub.graphics.beginFill(0xCC9999);
            hub.graphics.drawCircle(c, c, 5);

            _hHand = hHand;
            _mHand = mHand;
            _sHand = sHand;

            addChild(mHand);
            addChild(hHand);
            addChild(sHand);
            addChild(hub);

            var date:Date = new Date();

            // Since millisecond precision is not needed, round it up to the nearest second.
            var seconds:Number = date.seconds + ((date.milliseconds > 500) ? 1 : 0);
            var minutes:Number = date.minutes + seconds / 60;
            var hours:Number = (date.hours + minutes / 60) % 12;

            sHand.rotation = seconds * 6;
            mHand.rotation = minutes * 6;
            hHand.rotation = hours * 30;

            _timer = new Timer(1000);  // 1 second = 1000 ms
            _timer.addEventListener(TimerEvent.TIMER, _onTimerTick);
            _timer.start();

        }

        private function _onTimerTick(e:TimerEvent):void {
            _hHand.rotation += HOUR_HAND_CHANGE;
            _mHand.rotation += MINUTE_HAND_CHANGE;
            _sHand.rotation += SECOND_HAND_CHANGE;
        }

    }

}
