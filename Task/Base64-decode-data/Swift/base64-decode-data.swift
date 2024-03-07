import Foundation

let input = """
VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=
"""

if let decoded = Data(base64Encoded: input),
let str = String(data: decoded, encoding: .utf8) {
	print( str )
}
