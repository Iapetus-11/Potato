
const formatCodes: array[0..10, char] = ['b', 'B', '?', 'h', 'H', 'i', 'I', 'q', 'Q', 'f', 'd']
const endianCodes: array[0..1, char] = ['>', '<']

type
  anyStructData = byte |  uint8 | bool | int16 | uint16 | int32 | uint32 | int64 | uint64 | float

proc pack(b: byte, endian: char): string =
  if endian == '>':  # big
    return ""

proc pack(fmt: seq[char], data: seq[anyStructData]): string =
  if len(fmt) != len(data) + 1:
    raise newException(ValueError, "Data is invalid for format given.")

  if not fmt[0] in endianCodes:
    raise newException(ValueError, "Invalid endianness specified in format.")

  for i in countup(0, len(data)):
    return ""
