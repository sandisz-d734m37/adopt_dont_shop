require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should have_many(:pet_applications)}
    it {should have_many(:pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    # it { should validate_presence_of(:description) }
    # it { should validate_presence_of(:status) }
  end

  it 'updates status' do
    furry_friends = Shelter.create!(name: "Furry Friends", foster_program: true, city: "Denver", rank: "2")

    olive = furry_friends.pets.create!(name: "Olive", age: 2, breed: "dog", adoptable: true)

    application_4 = Application.create!(name: "Marky Mark", street_address: "678 I Way", city: "Richmond", zip_code: 23229, state: "VA", description: "Awaiting Information", status: "In progress")

    pet_application_5 = PetApplication.create!(pet_id: olive.id, application_id: application_4.id)

    application_4.update_status
    expect(application_4.status).to eq("Pending")

  end
end
