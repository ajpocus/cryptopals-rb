require_relative '../src/util'

RSpec.describe Util do
  it 'partitions an array' do
    a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    res = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(Util.partition(a, 3)).to eq(res)
  end
end
