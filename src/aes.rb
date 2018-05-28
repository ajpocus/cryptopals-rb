require 'openssl'
require_relative './bases'
require_relative './util'

module AES
  class << self
    BLOCK_SIZE = 16

    def ecb(text, key, mode)
      if !mode
        raise 'Mode must be explicitly passed in'
      end

      if !['encrypt', 'decrypt'].include?(mode)
        raise 'Invalid mode, must be one of "encrypt", "decrypt"'
      end

      cipher = OpenSSL::Cipher.new 'AES-128-ECB'
      case mode
      when 'encrypt'
        cipher.encrypt
      when 'decrypt'
        cipher.decrypt
      end
      cipher.key = key

      result = cipher.update(text)
      result << cipher.final

      result
    end

    def decrypt_ecb(ciphertext, key)
      ecb(ciphertext, key, 'decrypt')
    end

    def encrypt_ecb(plaintext, key)
      ecb(plaintext, key, 'encrypt')
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
