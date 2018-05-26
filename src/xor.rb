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
      lowest_score = Float::INFINITY

      keys.each do |key|
        plainbytes = self.single_byte_xor(cipherbytes, key)
        plaintext = Bases.bytes_to_ascii(plainbytes)
        puts plaintext
        score = EnglishJudge.score_plaintext(plaintext)
        puts score

        if score < lowest_score
          winning_plaintext = plaintext
          lowest_score = score
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
