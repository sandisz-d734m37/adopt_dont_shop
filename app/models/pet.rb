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

  def self.search_by_name(input)
    find_by(name: "#{input}")
  end

  def pet_app(pet_id, app_id)
    PetApplication.where("pet_id = #{pet_id} AND application_id = #{app_id}").first
  end

  def self.find_approved_applications(app_id)
    select("pets.*")
    .joins(:applications)
    .where("applications.status = 'Approved' AND applications.id = #{app_id}")
  end

  def self.find_pending_applications(shelter_id)
     select('pets.name, applications.id')
     .joins(:shelter, :applications)
     .where("shelters.id = #{shelter_id} AND applications.status != 'Approved' AND applications.status != 'Rejected'")
  end

  def update_adoptability
      update({adoptable: false})
  end
end
