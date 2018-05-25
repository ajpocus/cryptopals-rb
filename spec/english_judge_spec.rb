require_relative '../src/english_judge'

RSpec.describe EnglishJudge do
  it "scores plaintext" do
    score = EnglishJudge.score_plaintext('The quick fox jumped over the lazy brown dog.')
    expect(score).to eq(90007)
  end
end
