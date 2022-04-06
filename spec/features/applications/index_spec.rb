require 'rails_helper'

describe 'Admin Application Index page' do
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
      status: "Pending")

    PetApplication.create!(
      pet_id: @pet_2.id,
      application_id: @application_1.id
    )

    @application_2 = Application.create!(
      name: "Sharky Shark",
      street_address: "678 Wallaby Way",
      city: "Sydney",
      zip_code: 23229,
      state: "AUS",
      description: "I love dolls",
      status: "Pending")

    PetApplication.create!(
      pet_id: @pet_4.id,
      application_id: @application_2.id
    )
  end

  it 'displays all applications and their IDs' do
    visit '/applications'

    expect(page).to have_content("#{@application_1.name} #{@application_1.id}")
    expect(page).to have_content("#{@application_2.name} #{@application_2.id}")
  end
end
