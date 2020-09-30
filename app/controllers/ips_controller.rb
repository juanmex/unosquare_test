class IpsController < ApplicationController
    def create
        ip = params[:ip]
        result = IpValidator.new(ip).call
        render :json => {:message => result} 
    end
end
