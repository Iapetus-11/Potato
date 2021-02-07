from streams import Stream

from ../../types/packet import Packet

type
  HandshakeHandshake* = ref object of Packet
    protocol_version*: int16
    server_address*: string
    server_port*: int16
    next_state*: byte

proc new_HandshakeHandshake(v: int16, s: string, p: int16, n: byte): HandshakeHandshake =
  return HandshakeHandshake(protocol_version: v, server_address: s, server_port: p, next_state: n)

proc unpack_handshake(s: Stream): HandshakeHandshake =
  return new_HandshakeHandshake()
