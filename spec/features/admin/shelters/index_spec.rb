require 'rails_helper'

describe 'admin shelter index page' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'AAA Shelter', city: 'Denver, CO', foster_program: true, rank: 10)

    @moody = @shelter_2.pets.create!(name: 'Moody', breed: 'unidentified', age: 3, adoptable: true)
    @dilly = @shelter_4.pets.create!(name: 'Dilly', breed: 'unidentified', age: 3, adoptable: true)
    @pirate = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @clawdia = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
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
    @appl_3 = Application.create!(
      name: 'Doomy',
      street_address: '123 everywhere',
      city: 'NotHereTown',
      state: 'TH',
      zip_code: 12345,
      description: 'Awaiting Information...',
      status: 'Pending'
    )
    @appl_4 = Application.create!(
      name: 'Liddy',
      street_address: '1456 everywhere',
      city: 'HereHereTown',
      state: 'TH',
      zip_code: 12345,
      description: 'Awaiting Information...',
      status: 'Pending'
    )

    PetApplication.create!(pet_id: @moody.id, application_id: @appl_3.id)
    PetApplication.create!(pet_id: @pirate.id, application_id: @appl_1.id)
    PetApplication.create!(pet_id: @lucille.id, application_id: @appl_2.id)
    PetApplication.create!(pet_id: @dilly.id, application_id: @appl_4.id)

    visit '/admin/shelters'
  end

  it 'lists all shelters in reverse alphabeical order' do
    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it 'lists shelters with pending applications in their own section' do
    expect(page).to have_content("Shelter's with Pending Applications")
    within '#pending_shelters' do
      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_2.name)
      expect(page).not_to have_content(@shelter_3.name)
    end
  end

  it 'lists shelters with pending applications in alphabetical order' do
    within '#pending_shelters' do
      expect(@shelter_4.name).to appear_before(@shelter_1.name)
      expect(@shelter_1.name).to appear_before(@shelter_2.name)
      expect(page).not_to have_content(@shelter_3.name)
    end
  end

  it 'has links to shelter show pages' do
    click_link(@shelter_1.name)

    expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")
  end
end
