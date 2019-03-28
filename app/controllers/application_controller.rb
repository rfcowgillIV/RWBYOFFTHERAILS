class ApplicationController < ActionController::Base

    # TODO Later add a config file that would hide this from public view
    http_basic_authenticate_with name: "RWBY", password: "DUST", except: [:index, :show] 

    
end
