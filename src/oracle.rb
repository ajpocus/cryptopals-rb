require_relative './aes'
require_relative './util'

module Oracle
  class << self
    def encrypt_ecb_random(plaintext)
      plaintext = pad_random(plaintext)
      AES.ecb_encrypt(plaintext, AES.random_key)
    end

    def encrypt_cbc_random(plaintext)
      plaintext = pad_random(plaintext)
      AES.cbc_encrypt(plaintext, AES.random_key)
    end

    def pad_random(plaintext)
      num_bytes = rand(5, 11)
      random_bytes1 = Util.random_bytes(num_bytes)
      random_bytes2 = Util.random_bytes(num_bytes)
      random_text1 = Bases.bytes_to_ascii(random_bytes1)
      random_text2 = Bases.bytes_to_ascii(random_bytes2)
      
      random_text1 + plaintext + random_text2
    end

    def encrypt_random(plaintext)
      coin_flip = rand(2)
      if coin_flip.even?
        encrypt_ecb_random(plaintext)
      else
        encrypt_cbc_random(plaintext)
      end
    end
  end
end
