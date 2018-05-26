require_relative '../src/english_judge'

RSpec.describe EnglishJudge do
  it "scores plaintext" do
    score = EnglishJudge.score_plaintext('The quick fox jumped over the lazy brown dog.')
    expect(score).to be_an_instance_of(Float)
  end
end
