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