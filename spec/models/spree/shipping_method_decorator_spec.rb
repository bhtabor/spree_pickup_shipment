require 'spec_helper'

describe Spree::ShippingMethod, type: :model do

  let!(:stock_location) { FactoryBot.create(:stock_location) }
  let!(:pickup_location) { FactoryBot.create(:pickup_location, :with_timings) }
  let(:shipping_method) { FactoryBot.create(:shipping_method) }
  let(:shipping_method_with_pickupable_pickup_location) { FactoryBot.create(:shipping_method, pickupable: pickup_location) }
  let(:shipping_method_with_pickupable_stock_location) { FactoryBot.create(:shipping_method, pickupable: stock_location) }

  describe '#associations' do
    it { is_expected.to belong_to(:pickupable).optional }
  end

  describe '#pickupable' do
    context 'when pickupable is present' do
      it 'returns pickup location' do
        expect(shipping_method_with_pickupable_pickup_location.pickupable).to eq(pickup_location)
      end

      it 'returns stock location' do
        expect(shipping_method_with_pickupable_stock_location.pickupable).to eq(stock_location)
      end
    end
    
    context 'when pickupable is not present' do
      it 'returns nil' do
        expect(shipping_method.pickupable).to be_nil
      end
    end
  end

  describe '#pickupable?' do
    context 'when pickupable is present' do
      it 'returns true' do
        expect(shipping_method_with_pickupable_pickup_location.pickupable?).to eq(true)
        expect(shipping_method_with_pickupable_stock_location.pickupable?).to eq(true)
      end
    end

    context 'when pickupable is not present' do
      it 'returns false' do
        expect(shipping_method.pickupable?).to eq(false)
      end
    end
  end

end
