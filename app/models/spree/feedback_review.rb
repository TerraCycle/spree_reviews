class Spree::FeedbackReview < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class.to_s
  belongs_to :review, dependent: :destroy

  validates :review, presence: true

  validate :rating_within_bounds

  default_scope { most_recent_first }
  scope :most_recent_first, -> { order('spree_feedback_reviews.created_at DESC') }
  scope :localized, ->(lc) { where('spree_feedback_reviews.locale = ?', lc) }

  def rating_within_bounds
    return if rating.is_a?(Integer) && rating.between?(1, 5)

    errors.add(:rating, Spree.t('you_must_enter_value_for_rating'))
  end
end
