require_relative '../src/english_judge'

RSpec.describe EnglishJudge do
  it "scores plaintext" do
    english_judge = EnglishJudge.new
    score = english_judge.score_plaintext('The quick fox jumped over the lazy brown dog.')
    expect(score).to be_an_instance_of(Float)
  end
end
