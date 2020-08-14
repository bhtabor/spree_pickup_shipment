FactoryBot.define do
  factory :pickup_location, class: Spree::PickupLocation do
    sequence(:name) { |n| "Sample pickup location #{n}" }

    address1 { '1600 Pennsylvania Ave NW' }
    city { 'Washington' }
    zipcode { '20500' }
    phone { '(202) 456-1111' }

    state  { |pickup_location| pickup_location.association(:state) }
    country  { |pickup_location| pickup_location.association(:country) }

    start_time { Time.now }
    end_time { Time.now + 1.hour }

    trait :with_timings do |pickup_location|
      timings { FactoryBot.build_list(:timing, 2, pickup_location_id: pickup_location.id) }
    end
  end
end
