package  {
	
    import flash.display.GraphicsPathCommand;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	
    /**
     * A honeycomb.
     */
    public class Honeycomb extends Sprite {

        /**
         * The sine of 60 degrees.
         *
         * @private
         */
        private static const SIN_60:Number = Math.sin(Math.PI / 3);

        /**
         * The cosine of 60 degrees.
         *
         * @private
         */
        private static const COS_60:Number = Math.cos(Math.PI / 3);

        /**
         * The drawing commands to be passed to Graphics.drawPath()
         *
         * @private
         */
        private static var _gCommands:Vector.<int> = new Vector.<int>(7, true);

        /**
         * The coordinates to be passed to Graphics.drawPath()
         *
         * @private
         */
        private static var _gCoords:Vector.<Number> = new Vector.<Number>(14, true);

        /**
         * The side length of the last honeycomb created.
         */
        private static var _lastSide:Number;

        /**
         * The horizontal space difference (between the leftmost and topmost vertex) of the last hexagon drawn.
         *
         * @private
         */
        private static var _lastHSpace:Number;

        /**
         * The heightof the last hexagon drawn.
         *
         * @private
         */
        private static var _lastHeight:Number;

        {
            _staticInit();
        }

        /**
         * Initialises the Honeycomb class.
         *
         * @private
         */
        private static function _staticInit():void {
            _gCommands[0] = GraphicsPathCommand.MOVE_TO;
            _gCommands[1] = _gCommands[2] = _gCommands[3] = _gCommands[4] = _gCommands[5] = _gCommands[6] = GraphicsPathCommand.LINE_TO;
        }

        /**
         * Calculates the points of the hexagon for a given side length.
         *
         * @param side The length of the side.
         */
        private static function _calculatePoints(side:Number):void {

            var height:Number = side * SIN_60 * 2;
            var hSpace:Number = side * COS_60;

            _gCoords[0] = _gCoords[12] = 0;
            _gCoords[2] = _gCoords[10] = hSpace;
            _gCoords[4] = _gCoords[8] = hSpace + side;
            _gCoords[6] = side + hSpace * 2;

            _gCoords[1] = _gCoords[7] = _gCoords[13] = height / 2;
            _gCoords[3] = _gCoords[5] = height;
            _gCoords[9] = _gCoords[11] = 0;

            _lastSide = side;
            _lastHSpace = hSpace;
            _lastHeight = height;

        }

        /**
         * The side length of the honeycomb.
         *
         * @private
         */
        private var _side:Number;

        /**
         * The text field displaying the character in the honeycomb.
         *
         * @private
         */
        private var _text:TextField;

        /**
         * The character code of the character in the honeycomb.
         *
         * @private
         */
        private var _charCode:uint;

        /**
         * Whether the honeycomb has been activated (i.e. the activate() method has been called).
         *
         * @private
         */
        private var _activated:Boolean = false;

        /**
         * Creates a new Honeycomb object.
         *
         * @param side The length of the side of the honeycomb.
         * @param fill The honeycomb's fill colour.
         * @param letter The character code of the letter to be displayed in the honeycomb.
         * @param textColour The colour of the letter displayed inside the honeycomb.
         */
        public function Honeycomb(side:Number, fill:uint, letter:uint, textColour:uint) {
            _init(side, fill, letter, textColour);
        }

        /**
         * Initialises the Honeycomb object.
         *
         * @param side The length of the side of the honeycomb.
         * @param fill The honeycomb's fill colour.
         * @param letter The character code of the letter to be displayed in the honeycomb.
         * @param textColour The colour of the letter displayed inside the honeycomb.
         */
        private function _init(side:Number, fill:uint, letter:uint, textColour:uint):void {

            mouseChildren = false;
            buttonMode = true;
            useHandCursor = false;

            graphics.beginFill(fill);
            graphics.lineStyle(3, 0x000000);

            if ( side != _lastSide )
                _calculatePoints(side);

            _side = side;
            _charCode = letter;

            graphics.drawPath(_gCommands, _gCoords);

            _text = new TextField();
            _text.autoSize = TextFieldAutoSize.CENTER;
            _text.defaultTextFormat = new TextFormat('_sans', side * 1.2, textColour, true);
            _text.text = String.fromCharCode(letter);
            _text.x = (side + _lastHSpace * 2 - _text.width) / 2;
            _text.y = (_lastHeight - _text.height) / 2;

            addChild(_text);

        }

        /**
         * The character code of the character in the honeycomb.
         */
        public function get charCode():uint {
            return _charCode;
        }

        /**
         * Whether the honeycomb has been activated (i.e. the activate() method has been called).
         */
        public function get activated():Boolean {
            return _activated;
        }

        /**
         * Activates the honeycomb and changes its colour.
         *
         * @param backColour The new fill colour of the honeycomb.
         * @param textColour The new text colour of the honeycomb.
         */
        public function activate(backColour:uint, textColour:uint):void {

            if ( _side != _lastSide )
                _calculatePoints(_side);

            graphics.beginFill(backColour);
            graphics.drawPath(_gCommands, _gCoords);

            var textFormat:TextFormat = _text.getTextFormat();
            textFormat.color = textColour;
            _text.setTextFormat(textFormat);

            _activated = true;

        }

    }

}
