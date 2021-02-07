import strutils
import streams

type
  Buffer* = ref object of streams.Stream

proc unpack_varint(buf: Buffer, max_bits: int = 32): int =
  var num: int = 0
  var b: uint

  for i in countup(0, 10):
    b = buf.readUint8()

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

proc pack_varint(buf: Buffer, num: int, max_bits: int = 32) {.discardable.} =
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
      buf.write(uint8(b or 0x80))
    else:
      buf.write(uint8(b or 0))

    if num == 0:
      break

proc unpack_string(buf: Buffer): string =
  let length: int = buf.unpack_varint()
  var str: string

  for i in countup(0, length):
    str.add(buf.readChar())

  return str
