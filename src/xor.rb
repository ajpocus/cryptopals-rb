module Xor
  class << self
    def fixed_xor(bytes1, bytes2)
      pairs = bytes1.zip(bytes2)
      pairs.map { |b1, b2| b1 ^ b2 }
    end
  end
end
