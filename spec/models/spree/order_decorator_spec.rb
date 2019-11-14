require 'spec_helper'

describe Spree::Order, type: :model do

  describe 'validations' do
    it { should validate_inclusion_of(:shipment_state).in_array ["backorder", "canceled", "partial", "pending", "ready", "shipped", "shipped_for_pickup", "ready_for_pickup", "delivered"] }
  end

end
