require_relative '../src/aes'
require_relative '../src/bases'

RSpec.describe AES do
  it 'decrypts in ECB mode' do
    path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_7.txt')
    ciphertext = Bases.base64_to_ascii(File.read(path))
    plaintext = AES.decrypt_ecb(ciphertext, 'YELLOW SUBMARINE')
    puts plaintext
  end
end
