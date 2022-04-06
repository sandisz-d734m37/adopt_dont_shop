require 'rails_helper'

RSpec.describe 'application edit' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application_1 = Application.create!(
      name: "Sharky Shark",
      street_address: "678 Wallaby Way",
      city: "Sydney",
      zip_code: 23229,
      state: "AUS",
      description: "I love dolls",
      status: "In progress")

    PetApplication.create!(
      pet_id: @pet_2.id,
      application_id: @application_1.id
    )
  end

  describe 'edit application page' do
    it 'renders the edit application form' do
      visit "/applications/#{@application_1.id}/edit"

      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Street address')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('State')
      expect(find('form')).to have_content('Zip code')
      expect(find('form')).to have_content('Description')
      expect(find('form')).to have_content('Status')
      expect(find('form')).to have_button('Submit')
    end
  end
end
