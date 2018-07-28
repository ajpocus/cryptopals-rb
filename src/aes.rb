require 'openssl'
require_relative './bases'
require_relative './util'
require_relative './constants'

module AES
  class << self
    def ecb(text, key, mode, include_padding=true)
      self.check_mode!(mode)

      cipher = OpenSSL::Cipher.new 'AES-128-ECB'
      case mode
      when 'encrypt'
        cipher.encrypt
      when 'decrypt'
        cipher.decrypt
      end
      cipher.key = key
      if !include_padding
        cipher.padding = 0
      end

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

    def cbc(text, key, mode, iv=nil)
      check_mode!(mode)
      iv ||= "\x00" * Constants::BLOCK_SIZE
      last_block = iv

      given_blocks = Util.partition(text, Constants::BLOCK_SIZE)
      processed_blocks = given_blocks.map do |block|
        case mode
        when 'encrypt'
          xored_ascii = self.xor_block(block, last_block)
          processed_block = self.ecb(xored_ascii, key, mode, false)
          last_block = processed_block
        when 'decrypt'
          ecb_block = self.ecb(block, key, mode, false)
          processed_block = self.xor_block(ecb_block, last_block)
          last_block = block
        end

        processed_block
      end

      processed_blocks.join('')
    end

    def encrypt_cbc(plaintext, key, iv=nil)
      self.cbc(plaintext, key, 'encrypt', iv)
    end

    def decrypt_cbc(ciphertext, key, iv=nil)
      self.cbc(ciphertext, key, 'decrypt', iv)
    end

    def random_key
      random_bytes = Util.random_bytes(Constants::BLOCK_SIZE)
      Bases.bytes_to_ascii(random_bytes)
    end

    def check_mode!(mode)
      if !mode
        raise 'Mode must be explicitly passed in'
      end

      if !['encrypt', 'decrypt'].include?(mode)
        raise 'Invalid mode, must be one of "encrypt", "decrypt"'
      end
    end

    def xor_block(block, last_block)
      block_bytes = Bases.ascii_to_bytes(block)
      last_block_bytes = Bases.ascii_to_bytes(last_block)
      byte_pairs = block_bytes.zip(last_block_bytes)
      xored_bytes = byte_pairs.map { |a, b| a ^ b }
      Bases.bytes_to_ascii(xored_bytes)
    end
  end
end
