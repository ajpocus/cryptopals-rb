module Util
  class << self
    def partition(arr, len)
      blocks = []
      start = 0
      idx = len
      while start < arr.length
        blocks << arr.slice(start, len)
        start += len
      end

      if blocks.last.length != len
        block = blocks.last
        while block.length < len
          block << 0
        end
      end

      blocks
    end
  end
end
