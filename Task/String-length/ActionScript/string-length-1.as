package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.ByteArray;

    public class StringByteLength extends Sprite {

        public function StringByteLength() {
            if ( stage ) _init();
            else addEventListener(Event.ADDED_TO_STAGE, _init);
        }

        private function _init(e:Event = null):void {
            var s1:String = "The quick brown fox jumps over the lazy dog";
            var s2:String = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
            var s3:String = "José";

            var b:ByteArray = new ByteArray();
            b.writeUTFBytes(s1);
            trace(b.length);  // 43

            b.clear();
            b.writeUTFBytes(s2);
            trace(b.length);  // 28

            b.clear();
            b.writeUTFBytes(s3);
            trace(b.length);  // 5
        }

    }

}
