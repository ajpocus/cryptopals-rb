require_relative './spec_helper'
require_relative '../src/util'

describe Util do
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

  describe '#has_duplicate_blocks?' do
    it 'returns true when there are duplicate blocks' do
      b1 = [1] * 16
      b2 = [2] * 16
      b3 = [3] * 16
      b4 = [2] * 16

      blocks = [b1, b2, b3, b4]
      expect(Util.has_duplicate_blocks?(blocks)).to be true
    end

    it 'returns false when there are not duplicate blocks' do
      b1 = [1] * 16
      b2 = [2] * 16
      b3 = [3] * 16
      b4 = [4] * 16

      blocks = [b1, b2, b3, b4]
      expect(Util.has_duplicate_blocks?(blocks)).to be false
    end
  end
end
