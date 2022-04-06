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

  before do
    @furry_friends = Shelter.create!(name: "Furry Friends", foster_program: true, city: "Denver", rank: "2")

    @olive = @furry_friends.pets.create!(name: "Olive", age: 2, breed: "dog", adoptable: true)
    @brad = @furry_friends.pets.create!(name: "Brad", age: 2, breed: "unknown", adoptable: true)

    @application_1 = Application.create!(
      name: "Marky Mark",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "Awaiting Information",
      status: "In progress")

    @application_2 = Application.create!(
      name: "Sharky Shark",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "Awaiting Information",
      status: "In progress")

    @application_3 = Application.create!(
      name: "Darky Dark",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "",
      status: "In progress")

    @application_4 = Application.create!(
      name: "Dorky Dork",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "I have always wanted an unknown",
      status: "Pending")

    @application_5 = Application.create!(
      name: "Blorky Blork",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "I have always wanted an unknown",
      status: "Pending")

    @pet_application_5 = PetApplication.create!(
      pet_id: @olive.id, application_id: @application_1.id)

    @pet_application_1 = PetApplication.create!(
      pet_id: @brad.id, application_id: @application_4.id, pet_app_status: true)


    @pet_application_2 = PetApplication.create!(
      pet_id: @olive.id, application_id: @application_5.id, pet_app_status: false)
    @pet_application_3 = PetApplication.create!(
      pet_id: @brad.id, application_id: @application_5.id, pet_app_status: true)
  end

  describe 'instance methods' do
    describe '#updates_status' do
      it 'updates the application status if it has pets and a description' do
        @application_1.update_status
        expect(@application_1.status).to eq("Pending")
      end

      it 'does not update the application status if it DOES NOT have pets or a description' do
        @application_2.update_status
        expect(@application_2.status).to eq("In progress")

        @application_3.update_status
        expect(@application_3.status).to eq("In progress")
      end
    end

    describe '#approval' do
      it 'approves the application if all of the pets are approved' do
        @application_4.approval
        expect(@application_4.status).to eq("Approved")
      end

      it 'rejects the application if any of the pets are rejected' do
        @application_5.approval
        expect(@application_5.status).to eq("Rejected")
      end
    end
  end
end
