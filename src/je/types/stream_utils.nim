import strutils
import streams

proc unpack_bool*(s: Stream): bool =
  return bool(s.readUint8())

proc pack_bool*(s: Stream, b: bool) {.discardable.} =
  s.write(int8(b))

proc unpack_byte*(s: Stream): int =
  return int(s.readUint8())

proc pack_byte*(s: Stream, b: int) {.discardable.} =
  s.write(int8(b))

proc unpack_varint*(s: Stream, max_bits: int = 32): int =
  var num: int = 0
  var b: uint

  for i in countup(0, 10):
    b = s.readUint8()

    num = num or int((b and 0x7F) shl (7 * i))

    if not bool(b and 0x80):
      break

  if bool(num and (1 shl 31)):
    num -= 1 shl 32

  let num_min: int = (-1 shl (max_bits - 1))
  let num_max: int = (1 shl (max_bits - 1))

  if not (num_min <= num and num <= num_max):
    raise newException(ValueError, strutils.format("Value {num} must be within {num_min} and {num_max}."))

  return num

proc pack_varint*(s: Stream, num: int, max_bits: int = 32) {.discardable.} =
  let num_min: int = (-1 shl (max_bits - 1))
  let num_max: int = (1 shl (max_bits - 1))

  var num: int

  if not (num_min <= num and num <= num_max):
    raise newException(ValueError, strutils.format("Value {num} must be within {num_min} and {num_max}."))

  if num < 0:
    num += 1 + (1 shl 32)

  var b: int

  for i in countup(0, 10):
    b = num and 0x7F
    num = num shr 7

    if num > 0:
      s.write(uint8(b or 0x80))
    else:
      s.write(uint8(b or 0))

    if num == 0:
      break

proc unpack_string*(s: Stream): string =
  let length: int = s.unpack_varint()
  var str: string

  for i in countup(0, length):
    str.add(s.readChar())

  return str

proc pack_string*(s: Stream, str: string) {.discardable.} =
  s.pack_varint(len(str))
  s.write(str)
