class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha
  end

  def show
    @shelter = Shelter.find_by_sql("SELECT * FROM shelters WHERE id = #{params[:id]}").first
  end


end
