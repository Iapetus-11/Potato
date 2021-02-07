import src/je/net/packets/handshake
import src/je/types/buffer

echo handshake.HandshakeHandshake

var buf = Buffer()

echo repr(buf)
buf.pack_varint(123)
echo repr(buf)
