import streams

proc decodeMUTF8(s: string): string =
  let stringStream: StringStream = newStringStream(s)
  let length: int = len(s)

  var bytes: seq[int8] = @[]

  while not stringStream.atEnd():
    bytes.add(stringStream.readInt8())

  var i: int = 0
  var x: int8

  while i < length:
    x = bytes[i]

    if x == 0:
      raise newException(ValueError, "Embedded null byte in input.")

    if (x and 0b10000000) == 0b00000000: # ASCII
      x = x and 0x7F
      i += 1
    elif (x and 0b11100000) == 0b11000000: # 2 byte codepoint
      if i + 1 >= length:
        raise newException(ValueError, "2-byte codepoint started, but too short to finish.")

      x = ((bytes[i] and 0b00011111) shl 0x06) or (bytes[i + 1] and 0b00111111)
      i += 2
    elif x == 0b11101101:  # 6 byte codepoint
      if i + 5 > length:
        raise newException(ValueError, "6-byte codepoint started, but too short to finish.")

      x = int8(0x10000 or
        int((bytes[i+1] and 0b00001111) shl 0x10) or
        int((bytes[i+2] and 0b00111111) shl 0x0A) or
        int((bytes[i+4] and 0b00001111) shl 0x06) or
        int(bytes[i+5] and 0b00111111)
      )
