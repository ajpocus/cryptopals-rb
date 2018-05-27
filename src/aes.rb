require 'openssl'
require_relative './bases'
require_relative './util'

module AES
  class << self
    def decrypt_ecb(ciphertext, key)
      cipher = OpenSSL::Cipher.new 'AES-128-ECB'
      cipher.decrypt
      cipher.key = key

      decrypted = cipher.update(ciphertext)
      decrypted << cipher.final

      decrypted
    end

    def detect_ecb
      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_8.txt')
      lines = File.read(path).split(/\n/)
      high_score = 0
      winning_blocks = nil

      lines.each do |cipherhex|
        cipherbytes = Bases.hex_to_bytes(cipherhex)
        blocks = Util.partition(cipherbytes, 16, false)

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
  end
end
