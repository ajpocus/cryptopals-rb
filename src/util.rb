module Util
  class << self
    def partition(arr, len)
      parts = []
      start = 0
      idx = len
      while start < arr.length
        parts << arr.slice(start, len)
        start += len
      end

      parts
    end
  end
end
