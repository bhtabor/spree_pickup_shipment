require 'spec_helper'

describe Spree::ShippingRate, type: :model do


  let!(:pickup_location) { FactoryBot.create(:pickup_location, :with_timings) }
  let(:shipment) { create(:shipment) }
  let(:shipping_method) { FactoryBot.create(:shipping_method) }
  let(:shipping_rate) do
    Spree::ShippingRate.new shipment: shipment,
      shipping_method: shipping_method,
      cost: 10
  end
  let(:shipping_method_with_pickup_location) { FactoryBot.create(:shipping_method, pickup_location_id: pickup_location.id) }
  let(:shipping_rate_with_pickupable_shipping_method) do
    Spree::ShippingRate.new shipment: shipment,
      shipping_method: shipping_method_with_pickup_location,
      cost: 10
  end

  describe '#pickup_location_address' do
    context 'when shipping method is pickupable' do
      it 'returns address of pickup_location' do
        expect(shipping_rate_with_pickupable_shipping_method.pickup_location_address).to eq(shipping_method_with_pickup_location.pickup_location.address)
      end
    end

    context 'when shipping method is not pickupable' do
      it 'returns nil' do
        expect(shipping_rate.pickup_location_address).to be_nil
      end
    end
  end

  describe '#shipping_method_pickupable?' do
    context 'when shipping method is pickupable' do
      it 'returns true' do
        expect(shipping_rate_with_pickupable_shipping_method.shipping_method_pickupable?).to eq(true)
      end
    end

    context 'when shipping method is not pickupable' do
      it 'returns false' do
        expect(shipping_rate.shipping_method_pickupable?).to eq(false)
      end
    end
  end

end
