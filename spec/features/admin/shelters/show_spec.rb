require 'rails_helper'

describe 'admin shelter index page' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pirate = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @hariett = @shelter_1.pets.create!(name: 'Hariett', breed: 'Cat', age: 10, adoptable: false)
    @lucille = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @appl_1 = Application.create!(
      name: 'Johnny',
      street_address: '123 nowhere',
      city: 'HereTown',
      state: 'TH',
      zip_code: 99999,
      description: 'Awaiting Information...',
      status: 'Pending'
    )
    @appl_2 = Application.create!(
      name: 'Johnny',
      street_address: '123 nowhere',
      city: 'HereTown',
      state: 'TH',
      zip_code: 99999,
      description: 'Awaiting Information...',
      status: 'Rejected'
    )

    PetApplication.create!(pet_id: @pirate.id, application_id: @appl_1.id)
    PetApplication.create!(pet_id: @lucille.id, application_id: @appl_2.id)

    visit "/admin/shelters/#{@shelter_1.id}"
  end

  it 'shows the shelters name and full address' do
    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_1.city)
    expect(page).not_to have_content(@shelter_2.name)
    expect(page).not_to have_content(@shelter_2.city)
  end

  it 'shows the number of adoptable pets in the shelter' do
    within '#statistics' do
      expect(page).to have_content("#{@shelter_1.name} statistics:")
      expect(page).to have_content("Number of adoptable pets: 2")
    end
  end
end
