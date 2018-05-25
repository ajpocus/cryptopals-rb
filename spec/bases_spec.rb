require_relative '../src/bases'

RSpec.describe Bases do
  sample_hex = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
  sample_base64 = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

  it "converts hex to base64" do
    expect(Bases.hex_to_base64(sample_hex)).to eq(sample_base64)
  end

  it "converts base64 to hex" do
    expect(Bases.base64_to_hex(sample_base64)).to eq(sample_hex)
  end
end
