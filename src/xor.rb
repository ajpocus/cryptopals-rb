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
      winning_key = nil
      highest_score = 0
      english_judge = EnglishJudge.new

      keys.each do |key|
        plainbytes = self.single_byte_xor(cipherbytes, key)
        plaintext = Bases.bytes_to_ascii(plainbytes)
        score = english_judge.score_plaintext(plaintext)

        if score > highest_score
          winning_plaintext = plaintext
          highest_score = score
          winning_key = key
        end
      end

      [winning_plaintext, winning_key]
    end

    def detect_single_byte_xor
      keys = (0..255)
      winning_plaintext = nil
      highest_score = 0
      english_judge = EnglishJudge.new

      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_4.txt')
      File.foreach(path) do |cipherhex|
        cipherbytes = Bases.hex_to_bytes(cipherhex)
        plaintext = break_single_byte_xor(cipherbytes)
        score = english_judge.score_plaintext(plaintext)

        if score > highest_score
          winning_plaintext = plaintext
          highest_score = score
        end
      end

      winning_plaintext
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

    def break_repeating_key_xor
      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_6.txt')
      cipherbase64 = File.read(path).gsub(/\n/, '')
      cipherbytes = Bases.base64_to_bytes(cipherbase64)
      english_judge = EnglishJudge.new
      keysizes = (2..40)

      distances = {}
      keysizes.each do |keysize|
        block1 = cipherbytes.slice(0, keysize)
        block2 = cipherbytes.slice(keysize, keysize)
        s1 = Bases.bytes_to_ascii(block1)
        s2 = Bases.bytes_to_ascii(block2)
        distance = english_judge.hamming_distance(s1, s2)
        distances[keysize] = distance / keysize.to_f
      end

      potential_keysizes = distances.sort_by { |k, v| v }.take(5).map(&:first)
      puts potential_keysizes
      potential_plaintexts = []
      potential_keysizes.each do |keysize|
        blocks = Util.partition(cipherbytes, keysize)
        if blocks.last.length != keysize
          block = blocks.last
          while block.length < keysize
            block << 0
          end
        end

        transposed_blocks = blocks.transpose
        key_bytes = []

        transposed_blocks.each do |block|
          plaintext, key = self.break_single_byte_xor(block)
          key_bytes << key
        end

        potential_plaintexts << Bases.bytes_to_ascii(self.repeating_key_xor(cipherbytes, key_bytes))
      end

      winning_plaintext = nil
      highest_score = 0
      potential_plaintexts.each do |plaintext|
        score = english_judge.score_plaintext(plaintext)
        if score > highest_score
          winning_plaintext = plaintext
          highest_score = score
        end
      end

      puts winning_plaintext
    end
  end
end
