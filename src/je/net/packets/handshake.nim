import src/je/types/packet

type
  HandshakeHandshake* = ref object of packet.Packet
    const id: int = 0
    const to: int = 0
