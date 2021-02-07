import ../../types/packet

type
  HandshakeHandshake* = ref object of Packet
    protocol_version*: int
    server_address*: string
    server_port*: int
    next_state*: int

proc new_HandshakeHandshake(v: int, s: string, p: int, n: int): HandshakeHandshake =
  return HandshakeHandshake(protocol_version: v, server_address: s, server_port: p, next_state: n)

# proc unpack_handshake(buf: Buffer): HandshakeHandshake =
#   return unpack_varint()
