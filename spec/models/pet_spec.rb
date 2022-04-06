require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @pet_4 = @shelter_1.pets.create(name: 'Dann', breed: 'ragdoll', age: 3, adoptable: true)

    @application_1 = Application.create!(
      name: "Marky Mark",
      street_address: "678 I Way",
      city: "Richmond",
      zip_code: 23229,
      state: "VA",
      description: "Awaiting Information",
      status: "Pending")

    @application_2 = Application.create!(
      name: "Sharky Shark",
      street_address: "678 Wallaby Way",
      city: "Sydney",
      zip_code: 23229,
      state: "AUS",
      description: "I love dogs",
      status: "Approved")

    @application_3 = Application.create!(
      name: "Sharky Shark",
      street_address: "678 Wallaby Way",
      city: "Sydney",
      zip_code: 23229,
      state: "AUS",
      description: "I love dolls",
      status: "Pending")

    @pet_application_1 = PetApplication.create!(
      pet_id: @pet_1.id,
      application_id: @application_1.id)

    @pet_application_2 = PetApplication.create!(
      pet_id: @pet_2.id,
      application_id: @application_2.id)

    @pet_application_3 = PetApplication.create!(
      pet_id: @pet_4.id,
      application_id: @application_3.id)
  end

  describe 'class methods' do
    describe '#search' do
      it 'return partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
        expect(Pet.search("Pira")).to eq([@pet_1])
      end
      it 'case insensitive' do
        expect(Pet.search("claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2, @pet_4])
      end
    end

    describe '#search_by_name' do
      it 'searches by name' do
        expect(Pet.search_by_name("Clawdia")).to eq(@pet_2)
      end
    end

    describe '#find_approved_applications' do
      it 'returns all pets associated with an approved application' do
        expect(Pet.find_approved_applications(@application_2.id)).to eq([@pet_2])
      end
    end

    describe '#find_pending_applications' do
      it 'returns a list of pet names and pending application ID associated with a specified shelter' do
        expect(Pet.find_pending_applications(@shelter_1.id).first.name).to eq(@pet_1.name)
        expect(Pet.find_pending_applications(@shelter_1.id).first.id).to eq(@application_1.id)

        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@pet_1.breed)
        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@pet_1.id)
        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@application_1.name)
        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@application_1.street_address)

        expect(Pet.find_pending_applications(@shelter_1.id).last.name).to eq(@pet_4.name)
        expect(Pet.find_pending_applications(@shelter_1.id).last.id).to eq(@application_3.id)

        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@application_2.id)
        expect(Pet.find_pending_applications(@shelter_1.id)).not_to include(@pet_3.name)
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '#pet_app' do
      it 'returns a specific pet application' do
        expect(@pet_1.pet_app(@pet_1.id, @application_1.id)).to eq(@pet_application_1)
      end
    end

    describe '#update_adoptability' do
      it 'updates a pets adoptability, making them unadoptable' do
        @pet_4.update_adoptability
        expect(@pet_4.adoptable).to be(false)
      end
    end
  end
end
