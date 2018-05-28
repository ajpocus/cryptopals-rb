require_relative './aes'
require_relative './util'
require_relative './constants'

module Oracle
  class << self
    def encrypt_ecb_random(plaintext)
      plaintext = pad_random(plaintext)
      AES.ecb_encrypt(plaintext, AES.random_key)
    end

    def encrypt_cbc_random(plaintext)
      plaintext = pad_random(plaintext)
      random_iv = Util.random_string(BLOCK_SIZE)
      AES.cbc_encrypt(plaintext, AES.random_key)
    end

    def pad_random(plaintext)
      num_bytes = rand(5, 11)
      random_string1 = Util.random_string(num_bytes)
      random_string2 = Util.random_string(num_bytes)
      random_string1 + plaintext + random_string2
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
