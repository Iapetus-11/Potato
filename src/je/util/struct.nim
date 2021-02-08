import endians

const formatCodes: array[0..10, char] = ['b', 'B', '?', 'h', 'H', 'i', 'I', 'q', 'Q', 'f', 'd']
const endianCodes: array[0..1, char] = ['>', '<']

type
  anyStructData = byte |  uint8 | bool | int16 | uint16 | int32 | uint32 | int64 | uint64 | float

proc pack(b: byte, endian: char): byte =  # endianness doesn't matter here since it's just one byte
  return b

proc pack(b: uint8, endian: char): uint8 = # endianness again doesn't matter here since it's just one byte
  return b

proc pack(b: bool, endian: char): bool = # big woop endianness doesn't matter bc bool is just one byte
  return b

proc pack(h: int16, endian: char): int16 =
  var h: int16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc pack(h: uint16, endian: char): uint16 =
  var h: uint16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc pack(i: int32, endian: char): int32 =
  var i: int32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc pack(i: uint32, endian: char): uint32 =
  var i: uint32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc pack(fmt: seq[char], data: seq[anyStructData]): string =
  if len(fmt) != len(data) + 1:
    raise newException(ValueError, "Data is invalid for format given.")

  if not fmt[0] in endianCodes:
    raise newException(ValueError, "Invalid endianness specified in format.")

  for i in countup(0, len(data)):
    return ""
