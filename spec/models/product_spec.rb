require 'rails_helper'

RSpec.describe Product, type: :model do
  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:stock) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
end
