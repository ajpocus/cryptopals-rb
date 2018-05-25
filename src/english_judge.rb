module EnglishJudge
  class << self
    @@frequencies = [
      8.167,
      1.492,
      2.782,
      4.253,
      12.702,
      2.228,
      2.015,
      6.094,
      6.966,
      0.153,
      0.772,
      4.025,
      2.406,
      6.749,
      7.507,
      1.929,
      0.095,
      5.987,
      6.327,
      9.056,
      2.758,
      0.978,
      2.36,
      0.15,
      1.974,
      0.074
    ]

    def score_plaintext(plaintext)
      diff = 0

      @@frequencies.each_with_index do |frequency, index|
        letter = (97 + index).chr
        matches = plaintext.scan(/#{letter}/i).count
        freq_diff = (frequency - matches / plaintext.length).abs
        diff += freq_diff
      end

      diff
    end
  end
end
