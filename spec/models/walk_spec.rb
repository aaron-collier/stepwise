require 'rails_helper'

RSpec.describe Walk, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:walk)).to be_valid
    end

    %i[distance_miles steps walked_on].each do |attr|
      it "validates presence of #{attr}" do
        walk = build(:walk, attr => nil)
        expect(walk).not_to be_valid
        expect(walk.errors[attr]).to include("can't be blank")
      end
    end

    it 'validates distance_miles is greater than 0' do
      walk = build(:walk, distance_miles: 0)
      expect(walk).not_to be_valid
      expect(walk.errors[:distance_miles]).to include('must be greater than 0')
    end

    it 'validates distance_miles is numeric' do
      walk = build(:walk, distance_miles: -1.5)
      expect(walk).not_to be_valid
    end

    it 'validates steps is greater than 0' do
      walk = build(:walk, steps: 0)
      expect(walk).not_to be_valid
      expect(walk.errors[:steps]).to include('must be greater than 0')
    end

    it 'validates steps is an integer' do
      walk = build(:walk, steps: 1.5)
      expect(walk).not_to be_valid
      expect(walk.errors[:steps]).to include('must be an integer')
    end

    it 'validates walked_on is not in the future' do
      walk = build(:walk, walked_on: Date.tomorrow)
      expect(walk).not_to be_valid
      expect(walk.errors[:walked_on]).to include("can't be in the future")
    end

    it 'allows walked_on to be today' do
      walk = build(:walk, walked_on: Date.today)
      expect(walk).to be_valid
    end

    it 'allows walked_on to be in the past' do
      walk = build(:walk, walked_on: 1.week.ago.to_date)
      expect(walk).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end
