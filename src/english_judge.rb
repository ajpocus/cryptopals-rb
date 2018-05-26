require 'pry'

module EnglishJudge
  class << self
    @@frequencies = {
      a: 8.167,
      d: 4.253,
      e: 12.702,
      h: 6.094,
      i: 6.966,
      l: 4.025,
      n: 6.749,
      o: 7.507,
      r: 5.987,
      s: 6.327,
      t: 9.056,
      u: 2.758
    }

    def score_plaintext(plaintext)
      diff = 0
      letter_count = plaintext.scan(/\w/).count
      if letter_count == 0
        return Float::INFINITY
      end

      @@frequencies.each do |letter, frequency|
        matches = plaintext.scan(/#{letter}/i).count
        expected = letter_count * (frequency / 100)
        freq_diff = (expected - matches).abs
        chi2 = freq_diff ** 2 / frequency
        diff += chi2
      end

      diff
    end
  end
end
