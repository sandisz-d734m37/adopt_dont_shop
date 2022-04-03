class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def pet_app(pet_id, app_id)
    PetApplication.where("pet_id = #{pet_id} AND application_id = #{app_id}").first
  end

  def self.find_application(app_id)
    select("pets.*, applications.*")
    .joins(:applications)
    .where("applications.id = #{app_id}")
  end
  def self.find_pet_in_application(app_id)
    select("pets.*")
    .joins(:applications)
    .where("applications.id = #{app_id}")
  end


end
