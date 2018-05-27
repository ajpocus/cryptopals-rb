require_relative '../src/bases'
require_relative '../src/xor'

RSpec.describe Xor do
  it 'performs a fixed xor on two byte arrays of equal length' do
    hex1 = '1c0111001f010100061a024b53535009181c'
    hex2 = '686974207468652062756c6c277320657965'
    hex_result = '746865206b696420646f6e277420706c6179'

    b1 = Bases.hex_to_bytes(hex1)
    b2 = Bases.hex_to_bytes(hex2)

    expect(Xor.fixed_xor(b1, b2)).to eq(Bases.hex_to_bytes(hex_result))
  end

  it 'breaks single-byte xor' do
    cipherhex = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
    cipherbytes = Bases.hex_to_bytes(cipherhex)
    puts Xor.break_single_byte_xor(cipherbytes)
  end

  it 'detects single-byte xor' do
    puts Xor.detect_single_byte_xor
  end
end
