require_relative './aes'
require_relative './util'
require_relative './constants'

module Oracle
  class << self
    def encrypt_ecb_random(plaintext)
      plaintext = pad_with_string(plaintext)
      AES.encrypt_ecb(plaintext, AES.random_key)
    end

    def encrypt_cbc_random(plaintext)
      plaintext = pad_with_string(plaintext)
      random_iv = Util.random_string(Constants::BLOCK_SIZE)
      AES.encrypt_cbc(plaintext, AES.random_key, random_iv)
    end

    def pad_with_string(plaintext)
      num_bytes = rand(6) + 5
      string = Constants::BASE_TEXT.slice(0, num_bytes)
      string + plaintext + string
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
