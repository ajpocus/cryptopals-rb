require_relative './bases'
require 'set'

module Util
  class << self
    def partition(arr, len, pad_end=true)
      blocks = []
      start = 0
      idx = len
      while start < arr.length
        blocks << arr.slice(start, len)
        start += len
      end

      if pad_end && blocks.last.length != len
        block = blocks.last
        while block.length < len
          block << 0
        end
      end

      blocks
    end

    def pkcs7_padding(str, len)
      pad_len = len - str.length
      str << ("\\x%02d" % pad_len) * pad_len
      str
    end

    def random_bytes(len)
      len.times.map do
        rand(256)
      end
    end

    def random_string(len)
      Bases.bytes_to_ascii(random_bytes(len))
    end

    def has_duplicate_blocks?(blocks)
      blockset = Set.new(blocks)
      blockset.length != blocks.length
    end
  end
end
