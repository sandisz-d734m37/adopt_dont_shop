class PetApplicationsController < ApplicationController
#   def create
#     @pet_application = PetApplication.create!(pet_application_params)
#     redirect_to "/applications/#{@pet_application.application_id}"
#     @pet_application.save
#   end
#
#   private
#     def pet_application_params
#       params.permit(:application_id, :pet_id)
#     end
# end
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

    application = Application.find(params[:id])
    application.approval
    pets = Pet.find_approved_applications(params[:id])
      pets.each do |pet|
        pet.update_adoptability
      end
    redirect_to "/admin/applications/#{params[:id]}"
  end

  private

  def pet_application_params
    params.permit(:pet_id, :application_id, :pet_app_status)
  end
end
