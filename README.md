# README

## Instructions

- Create a Library on a Rails app environment.
- This Library should work to process IP addresses as text strings.
- Implement this module inside a Controller, which receives IP address string as param, which will decide if IP address is valid or not.
--- If valid, should print IP address
--- If invalid, should print "Invalid address" as text.

- Create the corresponding Unit tests for the Library, according to next definitions:
--- IP addresses is a string of four segment of integer numbers.
--- Each segment is separated by a dot character.
--- Each segment can have integer numbers from 0 to 255.
--- IP address for localhost is not a valid IP address.

* Write for Unit tests at least five scenarios for invalid IP addresses (ie: "192.34.5"), and at least one unit test for valid IP address.
* For unit tests, you can use rspec or any test suite you prefer.
* Upload code to a github public repository, and send repo address by email.


## Solución
Para mi solución he creado una API en Ruby On Rails

### Controller
El controlador se llama ips_controller y está en la ruta app/controllers/ips_controller.rb como es una API responde un json con el resultado en el atributo message
```bash
class IpsController < ApplicationController
    def create
        ip = params[:ip]
        result = IpValidator.new(ip).call
        render :json => {:message => result} 
    end
end
```

### Validator
Para construir el validador he generado una estructura de clases que usan al método call pero que cada una implementa el método validate.
```bash
class Validator
    def validate
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def call
        validate
    end
end


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

```
### Test
Creé un test llamado ip_validator_spec.rb Para probar el correcto funcionamiento de la clase IPValidator

```bash
require "rails_helper"
RSpec.describe 'IpValidator' do
    context 'is valid string but invalid ip' do
      it 'returns "Invalid address"' do
        expect(IpValidator.new("255.255.256.1").call).to eql("Invalid address")
        expect(IpValidator.new("300.0.a.1").call).to eql("Invalid address")
        expect(IpValidator.new("a.a.a.a").call).to eql("Invalid address")
        expect(IpValidator.new("n.255.zx213.123").call).to eql("Invalid address")
        expect(IpValidator.new("127.0.0.1").call).to eql("Invalid address")
      end
    end

    context 'is invalid string or param' do
        it 'return "Invalid address"' do
          expect(IpValidator.new("...").call).to eql("Invalid address")
          expect(IpValidator.new("255.256.1").call).to eql("Invalid address")
          expect(IpValidator.new("300..a.1").call).to eql("Invalid address")
          expect(IpValidator.new(123123123123).call).to eql("Invalid address")
          expect(IpValidator.new({:ip => "122.122.22.1"}).call).to eql("Invalid address")
          expect(IpValidator.new(["122.122.22.1"]).call).to eql("Invalid address")
          expect(IpValidator.new(nil).call).to eql("Invalid address")
        end
    end

    context 'is valid ip' do
        it 'return the IP' do
          expect(IpValidator.new("255.255.1.1").call).to eql("255.255.1.1")
          expect(IpValidator.new("89.45.72.210").call).to eql("89.45.72.210")
          expect(IpValidator.new("33.2.0.1").call).to eql("33.2.0.1")
          expect(IpValidator.new("25.25.87.98").call).to eql("25.25.87.98")
        end
    end
end
```