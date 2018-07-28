require_relative './spec_helper'
require_relative '../src/english_judge'
require_relative '../src/bases'

describe EnglishJudge do
  before do
    @english_judge = EnglishJudge.new
  end

  it "scores plaintext" do
    score = @english_judge.score_plaintext('The quick fox jumped over the lazy brown dog.')
    expect(score).to be_an_instance_of(Float)
  end

  it 'calculates the Hamming distance between two strings' do
    s1 = 'this is a test'
    s2 = 'wokka wokka!!!'
    b1 = Bases.ascii_to_bytes(s1)
    b2 = Bases.ascii_to_bytes(s2)
    expect(@english_judge.hamming_distance(b1, b2)).to eq(37)
  end
end
