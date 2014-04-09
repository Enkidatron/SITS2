class SitsAppController < ApplicationController
	respond_to :html

  def app
  	@ships = current_user.ships unless current_user.nil?
  	# For testing purposes, respond with all ships for now:
  	@ships = Ship.all 
  	respond_with(@ships)
  end
end
