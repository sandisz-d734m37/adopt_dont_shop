class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :pet_applications, through: :pets
  has_many :applications, through: :pet_applications

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.reverse_alpha
    Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  def self.shelter_pending
    shels = joins(:applications)
    shels.where("applications.status = 'Pending'").order(:name)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def adoptable_pet_count
    adoptable_pets.count
  end

  def avg_pet_age
    adoptable_pets.average(:age).to_f
  end

  def adopted_pet_count
    adopted = pets.where(adoptable: false)
    adopted.count
  end

  # def self.find_pending_applications(shelter_id)
  #    select('pets.*, applications.id, shelters.id')
  #    .joins(:pets, :applications)
  #    .where("shelters.id = #{shelter_id} AND applications.status != 'Approved' AND applications.status != 'Rejected'")
  # end

end
