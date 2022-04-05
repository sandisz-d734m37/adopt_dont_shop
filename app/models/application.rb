class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true
  # validates :description, presence: true
  validates :status, presence: true

  attribute :description, :string, default: ""
  # attribute :status, :string, default: "In progress"

  has_many :pet_applications
  has_many :pets, through: :pet_applications
  has_many :shelters, through: :pets


  def update_status
    if description == "" || pets.empty?
      update({status: 'In progress'})
    elsif description.length > 1 && !pets.empty?
      update({status: 'Pending'})
    end
  end

  def approval
    if pet_applications.all? {|pet_app| pet_app.pet_app_status == true}
      update({status: 'Approved'})
    elsif pet_applications.any? {|pet_app| pet_app.pet_app_status == false}
      update({status: 'Rejected'})
    end
  end

end
