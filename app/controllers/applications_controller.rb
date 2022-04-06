class ApplicationsController < ApplicationController
  def welcome
  end

  def index
    @applications = Application.all
  end

  def new
  end

  def create
    application = Application.create(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      # redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
      render :new
    end
  end

  def show
    if params[:pet_name].present?
      @application = Application.find(params[:id])
      @pet = Pet.search(params[:pet_name])
    else
      @application = Application.find(params[:id])
    end

    @selected_pets = @application.pets
    if params[:description] && @application.status != "Approved" && @application.status != "Rejected"
      @application.update({description: params[:description]})
      @application.update_status
      @application.save
    end
    # @application.update_status unless @application.status
  end

  def edit
    @application = Application.find(params[:id])
  end

  private

  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
