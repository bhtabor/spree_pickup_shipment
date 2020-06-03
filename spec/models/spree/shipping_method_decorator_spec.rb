require 'spec_helper'

describe Spree::ShippingMethod, type: :model do

  let!(:pickup_location) { FactoryBot.create(:pickup_location, :with_timings) }
  let(:shipping_method) { FactoryBot.create(:shipping_method) }
  let(:shipping_method_with_pickup_location) { FactoryBot.create(:shipping_method, pickup_location_id: pickup_location.id) }

  describe '#associations' do
    it { is_expected.to belong_to(:pickup_location).optional }
  end

  describe '#pickup_location_address' do
    context 'when pickup location is present' do
      it 'returns address of pickup_location' do
        expect(shipping_method_with_pickup_location.pickup_location_address).to eq(shipping_method_with_pickup_location.pickup_location.address)
      end
    end
    
    context 'when pickup location is not present' do
      it 'returns nil' do
        expect(shipping_method.pickup_location_address).to be_nil
      end
    end
  end

  describe '#pickupable?' do
    context 'when pickup location is present' do
      it 'returns true' do
        expect(shipping_method_with_pickup_location.pickupable?).to eq(true)
      end
    end

    context 'when pickup location is not present' do
      it 'returns false' do
        expect(shipping_method.pickupable?).to eq(false)
      end
    end
  end

end
