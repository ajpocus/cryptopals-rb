require_relative './spec_helper'
require_relative '../src/bases'
require_relative '../src/xor'

describe Xor do
  it 'performs a fixed xor on two byte arrays of equal length' do
    hex1 = '1c0111001f010100061a024b53535009181c'
    hex2 = '686974207468652062756c6c277320657965'
    hex_result = '746865206b696420646f6e277420706c6179'

    b1 = Bases.hex_to_bytes(hex1)
    b2 = Bases.hex_to_bytes(hex2)

    expect(Xor.fixed_xor(b1, b2)).to eq(Bases.hex_to_bytes(hex_result))
  end

  it 'performs repeating-key xor' do
    sample_plaintext = """Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"""
    sample_cipherhex = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f'
    key = 'ICE'
    plainbytes = Bases.ascii_to_bytes(sample_plaintext)
    cipherbytes = Bases.hex_to_bytes(sample_cipherhex)
    keybytes = Bases.ascii_to_bytes(key)

    expect(Xor.repeating_key_xor(plainbytes, keybytes)).to eq(cipherbytes)
  end
end
