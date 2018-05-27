require 'openssl'

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
  end

  def detect_ecb
    
  end
end
