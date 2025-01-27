require 'rails_helper'

RSpec.describe 'Mechanic show page' do 
  describe 'As a visitor' do 
    describe 'When I visit a mechanic show page' do 
      it 'will have their name, years of experience, and the names of all rides they are working on' do 
        park = AmusementPark.create!(name: "Six Flags", admission_cost: 10)
        ride1 = park.rides.create!(name: "Tower of doom", thrill_rating: 10, open: true)
        ride2 = park.rides.create!(name: "Splash Mountain", thrill_rating: 10, open: true)
        mechanic = Mechanic.create!(name: "Brian", years_experience: 0)
        RideMechanic.create!(mechanic: mechanic, ride: ride1)
        RideMechanic.create!(mechanic: mechanic, ride: ride2)
        # require 'pry'; binding.pry
        visit "/mechanics/#{mechanic.id}"

        expect(page).to have_content("Mechanic: #{mechanic.name}")
        expect(page).to have_content("Years of Experience: #{mechanic.years_experience}")
        expect(page).to have_content("Current rides they're working on")
        expect(page).to have_content("#{ride1.name}")

        expect(page).to have_content("#{ride1.name}")
      end

      it 'will have a form to add a ride to the mechanic' do 
        park = AmusementPark.create!(name: "Six Flags", admission_cost: 10)
        ride1 = park.rides.create!(name: "Tower of doom", thrill_rating: 10, open: true)
        ride2 = park.rides.create!(name: "Splash Mountain", thrill_rating: 10, open: true)
        mechanic = Mechanic.create!(name: "Brian", years_experience: 0)
        RideMechanic.create!(mechanic: mechanic, ride: ride1)
        RideMechanic.create!(mechanic: mechanic, ride: ride2)

        visit "/mechanics/#{mechanic.id}"
        
        within('.form') {
        expect(page).to have_content('Add a ride to workload:')
        expect(page).to have_field(:ride_id)
        expect(page).to have_button("Submit")
        }
      end

      it 'can fill the form out and add a new ride to a mechanic' do 
        park = AmusementPark.create!(name: "Six Flags", admission_cost: 10)
        ride1 = park.rides.create!(name: "Tower of doom", thrill_rating: 10, open: true)
        ride2 = park.rides.create!(name: "Splash Mountain", thrill_rating: 10, open: true)
        ride3 = park.rides.create!(name: "Twister", thrill_rating: 10, open: true)
        mechanic = Mechanic.create!(name: "Brian", years_experience: 0)
        RideMechanic.create!(mechanic: mechanic, ride: ride1)
        RideMechanic.create!(mechanic: mechanic, ride: ride2)

        visit "/mechanics/#{mechanic.id}"

        expect(page).to have_no_content(ride3.name)
        
        fill_in :ride_id, with: ride3.id
        click_button 'Submit'
        
        expect(page).to have_current_path("/mechanics/#{mechanic.id}")

        expect(page).to have_content(ride3.name)
      end
    end
  end
end