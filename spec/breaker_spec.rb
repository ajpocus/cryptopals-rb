require_relative '../src/breaker'

RSpec.describe Breaker do
  it 'breaks single-byte xor' do
    cipherhex = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
    cipherbytes = Bases.hex_to_bytes(cipherhex)
    plaintext, key = Breaker.break_single_byte_xor(cipherbytes)
    puts plaintext
  end

  it 'detects single-byte xor' do
    puts Breaker.detect_single_byte_xor
  end

  it 'breaks repeating-key xor' do
    puts Breaker.break_repeating_key_xor
  end

  it 'detects ECB mode' do
    pp Breaker.detect_ecb
  end
end
