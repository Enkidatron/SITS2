class SitsAppController < ApplicationController
	respond_to :html

  def app
  	respond_with(@ships= Ship.all)
  end
end
