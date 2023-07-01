/***************************************************************************\
|*  Pure UTF-8 handling without detailed error reporting functionality.    *|
|***************************************************************************|
|*  utf8encode                                                             *|
|*    < String character or UInt32 code point                              *|
|*    > Uint8Array encoded_character                                       *|
|*    | ErrorString                                                        *|
|*                                                                         *|
|*  utf8encode takes a string or uint32 representing a single code point   *|
|*    as its argument and returns an array of length 1 up to 4 containing  *|
|*    utf8 code units representing that character.                         *|
|***************************************************************************|
|*  utf8decode                                                             *|
|*    < Unit8Array [highendbyte highmidendbyte lowmidendbyte lowendbyte]   *|
|*    > uint32 character                                                   *|
|*    | ErrorString                                                        *|
|*                                                                         *|
|*  utf8decode takes an array of one to four uint8 representing utf8 code  *|
|*    units and returns a uint32 representing that code point.             *|
\***************************************************************************/

const
  utf8encode=
    n=>
      (m=>
        m<0x80
       ?Uint8Array.from(
          [ m>>0&0x7f|0x00])
       :m<0x800
       ?Uint8Array.from(
          [ m>>6&0x1f|0xc0,m>>0&0x3f|0x80])
       :m<0x10000
       ?Uint8Array.from(
          [ m>>12&0x0f|0xe0,m>>6&0x3f|0x80,m>>0&0x3f|0x80])
       :m<0x110000
       ?Uint8Array.from(
          [ m>>18&0x07|0xf0,m>>12&0x3f|0x80,m>>6&0x3f|0x80,m>>0&0x3f|0x80])
       :(()=>{throw'Invalid Unicode Code Point!'})())
      ( typeof n==='string'
       ?n.codePointAt(0)
       :n&0x1fffff),
  utf8decode=
    ([m,n,o,p])=>
      m<0x80
     ?( m&0x7f)<<0
     :0xc1<m&&m<0xe0&&n===(n&0xbf)
     ?( m&0x1f)<<6|( n&0x3f)<<0
     :( m===0xe0&&0x9f<n&&n<0xc0
      ||0xe0<m&&m<0xed&&0x7f<n&&n<0xc0
      ||m===0xed&&0x7f<n&&n<0xa0
      ||0xed<m&&m<0xf0&&0x7f<n&&n<0xc0)
    &&o===o&0xbf
     ?( m&0x0f)<<12|( n&0x3f)<<6|( o&0x3f)<<0
     :( m===0xf0&&0x8f<n&&n<0xc0
      ||m===0xf4&&0x7f<n&&n<0x90
      ||0xf0<m&&m<0xf4&&0x7f<n&&n<0xc0)
    &&o===o&0xbf&&p===p&0xbf
     ?( m&0x07)<<18|( n&0x3f)<<12|( o&0x3f)<<6|( p&0x3f)<<0
     :(()=>{throw'Invalid UTF-8 encoding!'})()
