class IpValidator < Validator
    INVALID_ADDRESSES = ["127.0.0.1"].freeze
    ERROR_MESSAGE = "Invalid address".freeze

    def initialize(ip)
        @ip = ip
    end

    def validate
        return ERROR_MESSAGE unless @ip.is_a? String
        return ERROR_MESSAGE if INVALID_ADDRESSES.include?(@ip)
        return ERROR_MESSAGE if !four_segments? || !valid_all_segments?
        return @ip
    end


    private
    def four_segments?
        segments.length == 4
    end

    def valid_all_segments?
        segments.each do |segment|
            return false unless valid_segment?(segment)
        end
        true
    end

    def segments
        @segments ||= @ip.split(".")
    end

    def valid_segment?(segment)
        return false unless segment.match(/^(\d)+$/) 
        int_segment = segment.to_i
        int_segment <= 255 && int_segment >= 0
    end
end
