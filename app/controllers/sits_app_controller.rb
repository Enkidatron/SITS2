class SitsAppController < ApplicationController
	respond_to :html

  def app
  	@ships = current_user.ships
  	respond_with(@ships)
  end
end
