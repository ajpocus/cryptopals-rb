require 'openssl'
require_relative './bases'
require_relative './util'

module AES
  class << self
    BLOCK_SIZE = 16

    def decrypt_ecb(ciphertext, key)
      cipher = OpenSSL::Cipher.new 'AES-128-ECB'
      cipher.decrypt
      cipher.key = key

      decrypted = cipher.update(ciphertext)
      decrypted << cipher.final

      decrypted
    end

    def encrypt_ecb(plaintext, key)
      cipher = OpenSSL::Cipher.new 'AES-128-ECB'
      cipher.encrypt
      cipher.key = key

      encrypted = cipher.update(plaintext)
      encrypted << cipher.final

      encrypted
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

    def encrypt_cbc(plaintext, key)
      iv = "\x00" * BLOCK_SIZE
      last_block = iv

      plain_blocks = Util.partition(plaintext, BLOCK_SIZE)
      encrypted_blocks = plain_blocks.map do |block|
        block_bytes = Bases.ascii_to_bytes(block)
        last_block_bytes = Bases.ascii_to_bytes(last_block)
        byte_pairs = block_bytes.zip(last_block_bytes)
        xored_bytes = byte_pairs.map { |a, b| a ^ b }
        xored_ascii = Bases.bytes_to_ascii(xored_bytes)

        encrypted_block = self.encrypt_ecb(xored_ascii, key)
        last_block = encrypted_block
        encrypted_block
      end

      Bases.ascii_to_bytes(encrypted_blocks.join(''))
    end

    def decrypt_cbc(ciphertext, key)
      iv = "\x00" * BLOCK_SIZE
      last_block = iv

      cipher_blocks = Util.partition(ciphertext, BLOCK_SIZE, false)
      decrypted_blocks = cipher_blocks.map do |block|
        block_bytes = Bases.ascii_to_bytes(block)
        last_block_bytes = Bases.ascii_to_bytes(last_block)
        byte_pairs = block_bytes.zip(last_block_bytes)
        xored_bytes = byte_pairs.map { |a, b| a ^ b }
        xored_ascii = Bases.bytes_to_ascii(xored_bytes)

        decrypted_block = self.decrypt_ecb(xored_ascii, key)
        last_block = decrypted_block
        decrypted_block
      end

      Bases.ascii_to_bytes(decrypted_blocks.join(''))
    end
  end
end
