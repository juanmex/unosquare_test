class Validator
    def validate
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def call
        validate
    end
end