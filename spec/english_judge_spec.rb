require_relative '../src/english_judge'

RSpec.describe EnglishJudge do
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

    expect(@english_judge.hamming_distance(s1, s2)).to eq(37)
  end
end
