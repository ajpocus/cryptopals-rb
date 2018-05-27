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

  def hamming_distance(s1, s2)
    bytes1 = Bases.ascii_to_bytes(s1)
    bytes2 = Bases.ascii_to_bytes(s2)

    byte_pairs = bytes1.zip(bytes2)

    byte_pairs.map { |b1, b2|
      (b1 ^ b2).to_s(2).count('1')
    }.reduce(&:+)
  end
end
