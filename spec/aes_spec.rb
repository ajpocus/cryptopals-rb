require 'pp'
require_relative '../src/aes'
require_relative '../src/bases'

RSpec.describe AES do
  it 'decrypts in ECB mode' do
    path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_7.txt')
    ciphertext = Bases.base64_to_ascii(File.read(path))
    plaintext = AES.decrypt_ecb(ciphertext, 'YELLOW SUBMARINE')
    puts plaintext
  end

  it 'detects ECB mode' do
    pp AES.detect_ecb
  end

  it 'encrypts and decrypts in ECB mode' do
    plaintext = 'Pocus was here'
    key = "SECRETTOEVERYONE"
    ciphertext = AES.encrypt_ecb(plaintext, key)
    processed_plaintext = AES.decrypt_ecb(ciphertext, key)
    expect(plaintext).to eq(processed_plaintext)
  end

  it 'decrypts in CBC mode' do
    path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_10.txt')
    cipherbase64 = File.read(path)
    ciphertext = Bases.base64_to_ascii(cipherbase64)
    puts AES.decrypt_cbc(ciphertext, 'YELLOW SUBMARINE')
  end
end
