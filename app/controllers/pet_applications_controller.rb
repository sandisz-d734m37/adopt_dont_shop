class PetApplicationsController < ApplicationController
  def update
    petappl = PetApplication.where("pet_id = #{params[:pet_id]} AND application_id = #{params[:id]}").first
      if params[:commit] == "Approve"
        petappl.pet_app_status = true
      elsif params[:commit] == "Reject"
        petappl.pet_app_status = false
      end

    petappl.save

    redirect_to "/admin/applications/#{params[:id]}"
  end

  private

  def application_params
    params.permit(:pet_id, :application_id, :pet_app_status)
  end
end
