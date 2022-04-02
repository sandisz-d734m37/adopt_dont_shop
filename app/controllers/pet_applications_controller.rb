class PetApplicationsController < ApplicationController
  def update
    petappl = PetApplication.where("pet_id = #{params[:pet_id]} AND application_id = #{params[:id]}").first
      if params[:commit] == "Approve"
        petappl.pet_app_status = true
      elsif params[:commit] == "Reject"
        petappl.pet_app_status = false
      end

    petappl.save

    application_with_pets = Application.pets_in_application(params[:id])
    application = Application.find(params[:id])
    if application_with_pets.all?{ |appl| appl.pet_app_status == true }
        application.status = "Approved"
        application.save
    end

    redirect_to "/admin/applications/#{params[:id]}"
  end

  private

  def application_params
    params.permit(:pet_id, :application_id, :pet_app_status)
  end
end
