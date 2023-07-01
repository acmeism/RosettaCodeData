package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class TwelveDaysOfChristmas extends Sprite {

        private var _textArea:TextField = new TextField();

        public function TwelveDaysOfChristmas() {
            if ( stage ) _init();
            else addEventListener(Event.ADDED_TO_STAGE, _init);
        }

        private function _init(e:Event = null):void {

            removeEventListener(Event.ADDED_TO_STAGE, _init);

            _textArea = new TextField();
            _textArea.x = 10;
            _textArea.y = 10;
            _textArea.autoSize = TextFieldAutoSize.LEFT;
            _textArea.wordWrap = true;
            _textArea.width = stage.stageWidth - 20;
            _textArea.height = stage.stageHeight - 10;
            _textArea.multiline = true;

            var format:TextFormat = new TextFormat();
            format.size = 14;
            _textArea.defaultTextFormat = format;

            var verses:Vector.<String> = new Vector.<String>(12, true);
            var lines:Vector.<String>;

            var days:Vector.<String> = new Vector.<String>(12, true);
            var gifts:Vector.<String> = new Vector.<String>(12, true);

            days[0] = 'first';
            days[1] = 'second';
            days[2] = 'third';
            days[3] = 'fourth';
            days[4] = 'fifth';
            days[5] = 'sixth';
            days[6] = 'seventh';
            days[7] = 'eighth';
            days[8] = 'ninth';
            days[9] = 'tenth';
            days[10] = 'eleventh';
            days[11] = 'twelfth';

            gifts[0] = 'A partridge in a pear tree';
            gifts[1] = 'Two turtle doves';
            gifts[2] = 'Three french hens';
            gifts[3] = 'Four calling birds';
            gifts[4] = 'Five golden rings';
            gifts[5] = 'Six geese a-laying';
            gifts[6] = 'Seven swans a-swimming';
            gifts[7] = 'Eight maids a-milking';
            gifts[8] = 'Nine ladies dancing';
            gifts[9] = 'Ten lords a-leaping';
            gifts[10] = 'Eleven pipers piping';
            gifts[11] = 'Twelve drummers drumming';

            var i:uint, j:uint, k:uint, line:String;

            for ( i = 0; i < 12; i++ ) {

                lines = new Vector.<String>(i + 2, true);
                lines[0] = "On the " + days[i] + " day of Christmas, my true love gave to me";

                j = i + 1;
                k = 0;
                while ( j-- > 0 )
                    lines[++k] = gifts[j];

                verses[i] = lines.join('\n');

                if ( i == 0 )
                    gifts[0] = 'And a partridge in a pear tree';

            }

            var song:String = verses.join('\n\n');
            _textArea.text = song;
            addChild(_textArea);

            _textArea.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);

        }

        private function _onKeyDown(e:KeyboardEvent):void {
            if ( e.keyCode == Keyboard.DOWN )
                _textArea.y -= 40;
            else if ( e.keyCode == Keyboard.UP )
                _textArea.y += 40;
        }

        private function _onMouseWheel(e:MouseEvent):void {
            _textArea.y += 20 * e.delta;
        }

    }

}
