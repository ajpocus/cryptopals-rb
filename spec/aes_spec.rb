require_relative './spec_helper'
require_relative '../src/aes'
require_relative '../src/bases'

describe AES do
  it 'decrypts in ECB mode' do
    path = File.join(File.dirname(__FILE__), '..', 'data', 'challenge_7.txt')
    ciphertext = Bases.base64_to_ascii(File.read(path))
    plaintext = AES.decrypt_ecb(ciphertext, 'YELLOW SUBMARINE')
    puts plaintext
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

  it 'generates a random AES key' do
    key = AES.random_key
    expect(key).to be_an_instance_of(String)
    expect(key.length).to eq(16)
  end
end
