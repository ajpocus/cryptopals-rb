require_relative './spec_helper'
require_relative '../src/breaker'
require 'pp'

describe Breaker do
  it 'breaks single-byte xor' do
    cipherhex = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
    cipherbytes = Bases.hex_to_bytes(cipherhex)
    plaintext, key = Breaker.break_single_byte_xor(cipherbytes)
    puts plaintext
  end

  it 'detects single-byte xor' do
    puts Breaker.detect_single_byte_xor
  end

  it 'breaks repeating-key xor' do
    puts Breaker.break_repeating_key_xor
  end

  it 'detects ECB mode' do
    pp Breaker.detect_ecb
  end

  it "detects whether it's ECB or CBC mode" do
  	TOTAL_RUNS = 1000
    mode_results = TOTAL_RUNS.times.map do
      Breaker.detect_mode
    end

    ecb_count = mode_results.count('ECB')
    cbc_count = mode_results.count('CBC')
    ecb_ratio = ecb_count / TOTAL_RUNS.to_f
    cbc_ratio = cbc_count / TOTAL_RUNS.to_f

    expect(ecb_ratio).to be_within(0.1).of(0.5)
    expect(cbc_ratio).to be_within(0.1).of(0.5)
  end
end
