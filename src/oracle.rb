require_relative './aes'
require_relative './util'
require_relative './constants'

RANDOM_KEY = AES.random_key

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
      string = Constants::PADDING_TEXT.slice(0, num_bytes)
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

    def encrypt_unknown(plaintext)
      path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_12.txt')
      unknown_base64 = File.read(path)
      unknown_text = Bases.base64_to_ascii(unknown_base64)
      puts "UNOWN: " + unknown_text[0]
      plaintext += unknown_text

      AES.encrypt_ecb(plaintext, RANDOM_KEY)
    end
  end
end
