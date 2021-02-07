import src/je/types/packet/Packet

type
  HandshakeHandshake* = ref object of Packet
    const id: int = 0
    const to: int = 0
