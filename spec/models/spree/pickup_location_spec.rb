require 'spec_helper'

describe Spree::PickupLocation, type: :model do

  let(:pickup_location) { FactoryBot.create(:pickup_location, :with_timings) }

  describe 'associations' do
    it { is_expected.to belong_to(:address) }
    it { is_expected.to have_many(:timings).dependent(:destroy) }
  end

  describe 'validations' do
    describe 'end_time_must_be_greater_than_start_time validation' do
      context 'when start_time time is less then end_time' do
        it 'is valid' do
          expect(pickup_location.valid?).to be_truthy
        end
      end

      context 'when start_time is more then end_time' do
        it 'adds error to pickup_location object' do
          pickup_location.end_time = pickup_location.start_time - 1.hour
          expect(pickup_location.valid?).to be_falsey
          expect(pickup_location.errors.full_messages).to include("End time " + Spree.t(:greater_than_start_time))
        end
      end
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:set_timings).before(:validation).if(:open_day_ids_changed?) }
    it { is_expected.to callback(:set_open_day_ids).after(:initialize) }
  end

  describe 'attr_accessor' do
    it { is_expected.to respond_to(:open_day_ids) }
    it { is_expected.to respond_to(:open_day_ids_was) }
  end

  describe 'private methods' do
    describe '#set_open_day_ids' do
      it 'sets open day ids' do
        expect(pickup_location.send(:set_open_day_ids)).to eq(pickup_location.timings.map(&:day_id))
      end
    end

    describe '#set_timings' do
      before do
        pickup_location.send(:set_open_day_ids)
        pickup_location.send(:set_timings)
      end

      it 'sets timings for pickup_location from open ids' do
        expect(pickup_location.timings.map(&:day_id)).to eq(pickup_location.open_day_ids)
      end
    end

    describe 'nested attributes' do
      it { is_expected.to accept_nested_attributes_for(:address) }
    end

    describe '#end_time_must_be_greater_than_start_time' do
      context 'when start_time time is less then end_time' do
        it 'returns nil' do
          expect(pickup_location.send(:end_time_must_be_greater_than_start_time)).to eq(nil)
        end
      end

      context 'when start_time is more then end_time' do
        before do
          pickup_location.update_attributes(start_time: pickup_location.end_time)
          pickup_location.update_attributes(end_time: pickup_location.end_time - 1.hour)
          pickup_location.send(:end_time_must_be_greater_than_start_time)
        end

        it 'adds error to pickup_location object' do
          expect(pickup_location.errors.full_messages).to include("End time " + Spree.t(:greater_than_start_time))
        end
      end
    end

    describe '#open_day_ids_changed?' do
      context 'when open_day_ids were changed' do
        before { pickup_location.open_day_ids = [1,2] }

        it 'returns true' do
          expect(pickup_location.send(:open_day_ids_changed?)).to be_truthy
        end
      end

      context 'when open_day_ids were not changed' do
        it 'returns false' do
          expect(pickup_location.send(:open_day_ids_changed?)).to be_falsey
        end
      end
    end
  end
end
