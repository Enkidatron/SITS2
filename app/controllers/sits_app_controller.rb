class SitsAppController < ApplicationController
	respond_to :html

  def app
  	@ships = current_user.ships unless current_user.nil?
  	respond_with(@ships)
  end
end
