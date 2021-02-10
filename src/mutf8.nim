import streams

proc decodeMUTF8*(s: string): string =
  let stringStream: StringStream = newStringStream(s)
  let length: int = len(s)

  var bytes: seq[int] = @[]

  while not stringStream.atEnd():
    bytes.add(stringStream.readInt8())

  var i: int = 0
  var x: int

  while i < length:
    x = bytes[i]

    if x == 0:
      raise newException(ValueError, "Embedded null byte in input.")

    if (x and 0b10000000) == 0b00000000:  # ASCII
      x = x and 0x7F
      i += 1
    elif (x and 0b11100000) == 0b11000000:  # 2 byte codepoint
      if i + 1 >= length:
        raise newException(ValueError, "2-byte codepoint started, but too short to finish.")

      x = ((bytes[i] and 0b00011111) shl 0x06) or (bytes[i + 1] and 0b00111111)
      i += 2
    elif x == 0b11101101:  # 6 byte codepoint
      if i + 5 > length:
        raise newException(ValueError, "6-byte codepoint started, but too short to finish.")

      x = (
        0x10000 or
        ((bytes[i+1] and 0b00001111) shl 0x10) or
        ((bytes[i+2] and 0b00111111) shl 0x0A) or
        ((bytes[i+4] and 0b00001111) shl 0x06) or
        (bytes[i+5] and 0b00111111)
      )

      i += 6
    elif (x shr 4) == 0b1110:  # 3 byte codepoint
      if i + 2 >= length:
        raise newException(ValueError, "3-byte codepoint started, but too short to finish.")

      x = (
        (bytes[i] and 0b00001111) shl 0x0C or
        (bytes[i + 1] and 0b00111111) shl 0x06 or
        (bytes[i + 2] and 0b00111111)
      )

      i += 3

    result &= char(x)

proc encodeMUTF8*(s: string): string =
  var c: int

  for chr in s:
    c = ord(chr)

    if c == 0x00:  # null byte
      result &= char(0xC0) & char(0x80)
    elif c <= 0x7F:  # ASCII
      result &= char(c)
    elif c <= 0x7FF:  # 2 byte codepoint
      result &= char(0xC0 or (0x1F and (c shr 0x06))) & char(0x80 or (0x3F and c))
    elif c <= 0xFFFF:  # 3 byte codepoint
      result &= char(0xE0 or (0x0F and (c shr 0x0C))) & char(0x80 or (0x3F and (c shr 0x06))) & char(0x80 or (0x3F and c))
    else:  # should be 6 byte codepoint
      result &= (
        char(0xED) &
        char(0xA0 or ((c shr 0x10) and 0x0F)) &
        char(0x80 or ((c shr 0x0A) and 0x3f)) &
        char(0xED) &
        char(0xb0 or ((c shr 0x06) and 0x0f)) &
        char(0x80 or (c and 0x3f))
      )
