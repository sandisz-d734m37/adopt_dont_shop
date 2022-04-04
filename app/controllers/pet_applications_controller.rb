class PetApplicationsController < ApplicationController

  def create
    @pet_application = PetApplication.create!(pet_application_params)
    redirect_to "/applications/#{@pet_application.application_id}"
    @pet_application.save
  end

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
    elsif application_with_pets.any?{ |appl| appl.pet_app_status == false }
      application.status = "Rejected"
      application.save
    end

    pet_in_app = Pet.find_application(params[:id])
    pets = Pet.find_pet_in_application(params[:id])
    if pet_in_app.any?{ |pet_ap| pet_ap.status == "Approved"}
      pets.each do |pet|
        pet.adoptable = false
        pet.save
      end
    end

    redirect_to "/admin/applications/#{params[:id]}"
  end

  private

  def pet_application_params
    params.permit(:pet_id, :application_id, :pet_app_status)
  end
end
