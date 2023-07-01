package  {
	
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
	
    /**
     * The Honeycomb game.
     */
    public class Main extends Sprite {

        /**
         * The fill colour for unselected honeycombs.
         *
         * @private
         */
        private static const FILL_COLOUR1:uint = 0xFFFF00;

        /**
         * The text colour for unselected honeycombs.
         *
         * @private
         */
        private static const FILL_COLOUR2:uint = 0xFF00FF;

        /**
         * The fill colour for selected honeycombs.
         *
         * @private
         */
        private static const TEXT_COLOUR1:uint = 0xFF0000;

        /**
         * The text colour for selected honeycombs.
         *
         * @private
         */
        private static const TEXT_COLOUR2:uint = 0x000000;

        /**
         * The honeycombs being displayed. They can be accesses using their character code as the key.
         *
         * @private
         */
        private var _honeycombs:Dictionary = new Dictionary();

        /**
         * The text field showing the selected letters.
         *
         * @private
         */
        private var _selectedLettersOutputField:TextField;

        /**
         * Entry point of the application.
         */
        public function Main() {
            if ( stage ) init();
            else addEventListener(Event.ADDED_TO_STAGE, init)
        }

        /**
         * Initialises the Main object when it is added to the stage.
         *
         * @private
         */
        private function init(e:Event = null):void {

            removeEventListener(Event.ADDED_TO_STAGE, init);

            var side:uint = 35;
            var hSpace:Number = side * Math.cos(Math.PI / 3);
            var height:Number = side * Math.sin(Math.PI / 3) * 2;

            var i:uint, j:uint, comb:Honeycomb, colX:Number = 0, rowY:Number = 0, char:uint;
            var usedCodes:Vector.<uint> = new Vector.<uint>();

            for ( i = 0; i < 5; i++ ) {
                for ( j = 0; j < 4; j++ ) {

                    // Select a character to display. If it is already used, repeat this process until an unused
                    // character is found.

                    do
                        char = uint(Math.random() * 26) + 0x41;
                    while ( usedCodes.indexOf(char) != -1 );

                    usedCodes[usedCodes.length] = char;

                    comb = new Honeycomb(side, FILL_COLOUR1, char, TEXT_COLOUR1);
                    comb.x = colX + 30;
                    comb.y = rowY + 30 + height * j;
                    addChild(comb);

                    _honeycombs[char] = comb;

                }

                if ( rowY == 0 )
                    rowY = height / 2;
                else
                    rowY = 0;

                colX += side + hSpace;
            }

            _selectedLettersOutputField = new TextField();
            _selectedLettersOutputField.x = 30;
            _selectedLettersOutputField.y = 30 + height * 5;
            _selectedLettersOutputField.defaultTextFormat = new TextFormat(null, 18);
            _selectedLettersOutputField.multiline = true;
            _selectedLettersOutputField.autoSize = TextFieldAutoSize.LEFT;
            _selectedLettersOutputField.text = "Selected letters:\n";

            addChild(_selectedLettersOutputField);

            // Since the MouseEvent.CLICK event bubbles, it is sufficient to add the listener to the Main object
            // itself rather than to each honeycomb individually, and the event's target property will always
            // be the clicked honeycomb.

            addEventListener(MouseEvent.CLICK, _onMouseClick);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);

        }

        /**
         * Function called when a honeycomb is clicked.
         *
         * @private
         */
        private function _onMouseClick(e:MouseEvent):void {
            var comb:Honeycomb = e.target as Honeycomb;

            if ( comb && ! comb.activated ) {
                comb.activate(FILL_COLOUR2, TEXT_COLOUR2);
                _selectedLettersOutputField.appendText(String.fromCharCode(comb.charCode));
            }
        }

        /**
         * Function called when a keyboard key is pressed.
         *
         * @private
         */
        private function _onKeyDown(e:KeyboardEvent):void {
            var char:uint = e.charCode;
            if ( char > 0x60 )
                // Convert lowercase to uppercase
                char -= 0x20;

            var comb:Honeycomb = _honeycombs[char] as Honeycomb;

            if ( comb && ! comb.activated ) {
                comb.activate(FILL_COLOUR2, TEXT_COLOUR2);
                _selectedLettersOutputField.appendText(String.fromCharCode(char));
            }
        }

    }

}
