require 'pry'

class EnglishJudge
  def initialize
    @frequencies = {}
    path = File.join(File.dirname(__FILE__), '..', 'data', 'english_bigrams_1.txt')
    File.foreach(path) do |line|
      bigram, count = line.split(' ')
      @frequencies[bigram] = Math.log(count.to_i) ** 2
    end
  end

  def score_plaintext(plaintext)
    score = 0
    letter_count = plaintext.scan(/\w/).count
    if letter_count == 0
      return 0
    end

    @frequencies.each do |bigram, frequency|
      matches = plaintext.scan(/#{bigram}/i).count
      score += frequency * matches
    end

    score
  end
end
