require 'spec_helper'

describe Spree::Shipment, type: :model do

  let!(:delivered_shipment) { FactoryBot.create(:shipment, pickup: true, state: 'delivered') }
  let!(:shipped_for_pickup_shipment) { FactoryBot.create(:shipment, pickup: true, state: 'shipped_for_pickup') }
  let!(:ready_for_pickup_shipment) { FactoryBot.create(:shipment, pickup: true, state: 'ready_for_pickup') }
  let(:order) { FactoryBot.create(:order_with_line_items) }
  let(:shipment) { FactoryBot.create(:shipment, order: order) }
  let(:shipping_method_not_pickupable) { FactoryBot.create(:shipping_method) }
  let(:pickup_location) { FactoryBot.create(:pickup_location, :with_timings) }
  let(:shipping_method_pickupable) { FactoryBot.create(:shipping_method, pickup_location: pickup_location) }

  describe 'scopes' do
    describe 'delivered' do
      it 'returns delivered shipments' do
        expect(Spree::Shipment.delivered.first).to eq(delivered_shipment)
      end
    end

    describe 'shipped_for_pickup' do
      it 'returns shipment which are ready for pickup' do
        expect(Spree::Shipment.shipped_for_pickup.first).to eq(shipped_for_pickup_shipment)
      end
    end

    describe 'ready_for_pickup' do
      it 'returns shipment which are ready for pickup' do
        expect(Spree::Shipment.ready_for_pickup.first).to eq(ready_for_pickup_shipment)
      end
    end
  end

  describe 'instance methods' do
    describe '#finalized' do
      context 'when finalized state includes shipment state' do
        it 'returns true' do
          expect(ready_for_pickup_shipment.finalized?).to be_truthy
        end
      end

      context 'when finalized state does not include shipment state' do
        it 'returns false' do
          expect(shipment.finalized?).to be_falsey
        end
      end
    end

    describe "#selected_shipping_rate_id=" do
      context "when shipping_method is pickupable?" do
        before do
          shipment.shipping_rates.create shipping_method: shipping_method_pickupable, cost: 10.00, selected: false
        end

        it "sets address_id to pickup_location address_id and pickup to true" do
          shipment.selected_shipping_rate_id = shipment.shipping_rates.first.id

          expect(shipment.address_id).to eq pickup_location.address.id
          expect(shipment.pickup).to be_truthy
        end
      end

      context "when shipping_method is not pickupable?" do
        before do
          shipment.shipping_rates.create shipping_method: shipping_method_not_pickupable, cost: 10.00, selected: false
        end

        it "sets address_id to order ship_address_id and pickup to false" do
          shipment.selected_shipping_rate_id = shipment.shipping_rates.first.id

          expect(shipment.address_id).to eq shipment.order.ship_address_id
          expect(shipment.pickup).to be_falsey
        end
      end
    end
  end

  describe '#private methods' do

    describe 'update_order_shipment' do
      it 'updates order shipment' do
        expect(shipment.send(:update_order_shipment)).to be_truthy
      end
    end
  end
end
