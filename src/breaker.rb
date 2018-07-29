require_relative './xor'
require_relative './bases'
require_relative './aes'
require_relative './oracle'
require_relative './constants'
require 'pp'

module Breaker
  class << self
    def break_single_byte_xor(cipherbytes)
      keys = (0..255)
      winning_plaintext = nil
      winning_key = nil
      highest_score = 0
      english_judge = EnglishJudge.new

      keys.each do |key|
        plainbytes = Xor.single_byte_xor(cipherbytes, key)
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
        plaintext, key = break_single_byte_xor(cipherbytes)
        score = english_judge.score_plaintext(plaintext)

        if score > highest_score
          winning_plaintext = plaintext
          highest_score = score
        end
      end

      winning_plaintext
    end

    def break_repeating_key_xor
      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_6.txt')
      cipherbase64 = File.read(path).gsub(/\n/, '')
      cipherbytes = Bases.base64_to_bytes(cipherbase64)
      english_judge = EnglishJudge.new
      keysizes = (2..40)

      distances = {}
      keysizes.each do |keysize|
        4.times.each do |i|
          block1 = cipherbytes.slice(i*keysize, keysize)
          block2 = cipherbytes.slice(i*keysize+keysize, keysize)
          distances[keysize] ||= 0
          distances[keysize] += english_judge.hamming_distance(block1, block2) / keysize
        end
      end

      potential_keysizes = distances.sort_by { |k, v| v }.take(4).map(&:first)
      potential_plaintexts = []
      potential_keysizes.each do |keysize|
        blocks = Util.partition(cipherbytes, keysize)
        transposed_blocks = blocks.transpose
        key_bytes = []

        transposed_blocks.each do |block|
          plaintext, key = self.break_single_byte_xor(block)
          key_bytes << key
        end

        potential_plaintexts << Bases.bytes_to_ascii(Xor.repeating_key_xor(cipherbytes, key_bytes))
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

      winning_plaintext
    end

    def detect_ecb
      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_8.txt')
      lines = File.read(path).split(/\n/)
      high_score = 0
      winning_blocks = nil

      lines.each do |cipherhex|
        cipherbytes = Bases.hex_to_bytes(cipherhex)
        blocks = Util.partition(cipherbytes, Constants::BLOCK_SIZE, false)

        char_counts = {}
        blocks.each do |block|
          block_sig = block.join(',')
          char_counts[block_sig] ||= 0
          char_counts[block_sig] += 1
        end

        sum = 0
        char_counts.each do |char, count|
          if count > 1
            sum += count
          end
        end

        if sum > high_score
          high_score = sum
          winning_blocks = blocks
        end
      end

      winning_blocks
    end

    def detect_mode
      plaintext = Constants::BASE_TEXT * 16
      ciphertext = Oracle.encrypt_random(plaintext)
      cipherbytes = Bases.ascii_to_bytes(ciphertext)
      blocks = Util.partition(cipherbytes, 16, false)

      if Util.has_duplicate_blocks?(blocks)
        'ECB'
      else
        'CBC'
      end
    end

    def break_unknown
      # detect block size
      block_size = nil
      last_block_seen = nil

      32.times.each do |i|
        plaintext = 'A' * i
        ciphertext = Oracle.encrypt_unknown(plaintext)
        cipherbytes = Bases.ascii_to_bytes(ciphertext)

        cipherblocks = Util.partition(cipherbytes, 16, false)
        first_block = cipherblocks[0]

        if first_block == last_block_seen
          block_size = i - 1
          break
        else
          last_block_seen = first_block
        end
      end

      puts block_size

      plaintext = 'A' * (block_size * 2)
      ciphertext = Oracle.encrypt_unknown(plaintext)
      cipherbytes = Bases.ascii_to_bytes(ciphertext)

      cipherblocks = Util.partition(cipherbytes, 16, false)
      first_block = cipherblocks[0]
      second_block = cipherblocks[1]
      is_ecb = first_block == second_block

      if !is_ecb
        raise Exception.new('This is not ECB. Something is terribly wrong.')
      end

      short_plaintext = 'A' * (block_size - 1)
      ciphertext = Oracle.encrypt_unknown(short_plaintext)
      cipherbytes = Bases.ascii_to_bytes(ciphertext)
      short_block = Util.partition(cipherbytes, 16, false)[0]

      test_blocks = 256.times.map do |i|
        plainbytes = Bases.ascii_to_bytes(short_plaintext)
        plainbytes << i
        plaintext = Bases.bytes_to_ascii(plainbytes)
        ciphertext = Oracle.encrypt_unknown(plaintext)
        cipherbytes = Bases.ascii_to_bytes(ciphertext)
        Util.partition(cipherbytes, 16, false)[0]
      end

      winning_block = test_blocks.select { |b| b == short_block }
      pp winning_block
      first_byte = winning_block.first.last

      puts "FIRST: " + first_byte.to_s
      first_byte
    end
  end
end
