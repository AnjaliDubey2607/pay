class BillingController < ApplicationController


    def index
     @user=current_user.email
    end
    def pay
        
    end

end
