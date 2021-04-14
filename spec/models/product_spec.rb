require "rails_helper"

RSpec.describe Product, type: :model do
  let(:params) { %i[price_list brand code stock cost] }

  it { is_expected.to validate_numericality_of(:cost) }

  it "validates the presence params of" do
    params.each do |param|
      is_expected.to validate_presence_of(param.to_sym)
    end
  end
end
