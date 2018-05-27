require_relative '../src/util'

RSpec.describe Util do
  it 'partitions an array' do
    a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    res = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(Util.partition(a, 3)).to eq(res)
  end

  it 'pads ASCII with PKCS#7' do
    sample_text = 'YELLOW SUBMARINE'
    pad_len = 20
    res = 'YELLOW SUBMARINE\x04\x04\x04\x04'

    expect(Util.pkcs7_padding(sample_text, pad_len)).to eq(res)
  end
end
