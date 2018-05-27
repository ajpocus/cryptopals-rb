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
  end
end
