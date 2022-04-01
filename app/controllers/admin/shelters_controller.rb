class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha
  end

  def show
    @shelter = Shelter.find(params[:id])
  end


end
