require_relative './english_judge'
require_relative './bases'

module Xor
  class << self
    def fixed_xor(bytes1, bytes2)
      pairs = bytes1.zip(bytes2)
      pairs.map { |b1, b2| b1 ^ b2 }
    end

    def break_single_byte_xor(cipherbytes)
      keys = (0..255)
      winning_plaintext = nil
      lowest_score = 100000

      keys.each do |key|
        plainbytes = self.single_byte_xor(cipherbytes, key)
        plaintext = Bases.bytes_to_ascii(plainbytes)
        score = EnglishJudge.score_plaintext(plaintext)

        if score < lowest_score
          winning_plaintext = plaintext
        end
      end

      winning_plaintext
    end

    def single_byte_xor(plainbytes, key)
      keybytes = Array.new(plainbytes.length, key)
      self.fixed_xor(plainbytes, keybytes)
    end
  end
end