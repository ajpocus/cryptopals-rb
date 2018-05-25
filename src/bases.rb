require 'base64'

module Bases
  class << self
    def base64_to_ascii(base64)
      Base64.decode64(base64)
    end

    def base64_to_bytes(base64)
      self.base64_to_ascii(base64).bytes
    end

    def base64_to_hex(base64)
      self.bytes_to_hex(self.base64_to_bytes(base64))
    end

    def bytes_to_ascii(bytes)
      bytes.map(&:chr).join('')
    end

    def bytes_to_base64(bytes)
      Base64.encode64(self.bytes_to_ascii(bytes)).gsub(/\n/, '')
    end

    def bytes_to_hex(bytes)
      bytes.map { |b| b.to_s(16) }.join('')
    end

    def hex_to_base64(hex)
      self.bytes_to_base64(self.hex_to_bytes(hex))
    end

    def hex_to_bytes(hex)
      [hex].pack('H*').unpack('C*')
    end
  end
end
