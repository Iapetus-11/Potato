from streams import Stream, write, readChar
import encodings
import strutils

import ../struct

proc packVarInt(s: Stream, num: int, maxBits: int = 32) =
  let numMin = (-1 shl (maxBits - 1))
  let numMax = (1 shl (maxBits - 1))

  if not (numMin <= num and num < numMax):
    raise newException(ValueError, strutils.format("Number {num} doesn't fit within {numMin} and {numMax}"))

  var num: int = num
  var b: int

  if num < 0:
    num += 1 + (1 shl 32)

  for i in countup(0, 10):
    b = num and 0x7f
    num = num shr 7

    if num > 0:
      struct.pack(s, '>', 'B', (b or 0x80))
    else:
      struct.pack(s, '>', 'B', (b or 0))

    if num == 0:
      break

proc unpackVarInt(s: Stream, maxBits: int = 32): int =
  var num: int = 0
  var b: int

  for i in countup(0, 10):
    b = struct.unpackByte(s)
    num = num or ((b and 0x7f) shl (7 * i))

    if not bool(b and 0x80):
      break

  if bool(num and (1 shl 31)):
    num -= 1 shl 32

  let numMin = (-1 shl (maxBits - 1))
  let numMax = (1 shl (maxBits - 1))

  if not (numMin <= num and num < numMax):
    raise newException(ValueError, strutils.format("Number {num} doesn't fit within {numMin} and {numMax}"))

  return num

proc packString(s: Stream, text: string) =
  let text: string = encodings.convert(text, "UTF-8", encodings.getCurrentEncoding())

  packVarInt(s, len(text))
  s.write(text)

proc unpackString(s: Stream): string =
  let length: int = unpackVarInt(s)

  for _ in countup(0, length):
    result &= s.readChar()

  result = encodings.convert(result, encodings.getCurrentEncoding(), "UTF-8")
