require_relative './english_judge'
require_relative './bases'

module Xor
  class << self
    def fixed_xor(bytes1, bytes2)
      pairs = bytes1.zip(bytes2)
      pairs.map { |b1, b2| b1 ^ b2 }
    end

    def single_byte_xor(plainbytes, key)
      keybytes = Array.new(plainbytes.length, key)
      self.fixed_xor(plainbytes, keybytes)
    end

    def repeating_key_xor(plainbytes, keybytes)
      key = Bases.bytes_to_ascii(keybytes)
      key = (key * (plainbytes.length / key.length + 1)).slice(0, plainbytes.length)
      keybytes = Bases.ascii_to_bytes(key)
      self.fixed_xor(plainbytes, keybytes)
    end
  end
end
