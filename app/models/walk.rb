class Walk < ApplicationRecord
  belongs_to :user

  scope :recent, ->(n) { order(walked_on: :desc, created_at: :desc).limit(n) }

  validates :distance_miles, :steps, :walked_on, presence: true
  validates :distance_miles, numericality: { greater_than: 0 }
  validates :steps, numericality: { greater_than: 0, only_integer: true }
  validate :walked_on_not_in_future

  private

  def walked_on_not_in_future
    return if walked_on.blank?
    errors.add(:walked_on, "can't be in the future") if walked_on > Date.today
  end
end
