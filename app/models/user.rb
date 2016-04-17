class User < ActiveRecord::Base

  has_many :rooms, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reviewed_rooms, through: :reviews, source: :room

  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  validates_presence_of :email, :full_name, :location
  validates_length_of :bio, minimum: 30, allow_blank: false
  validates_format_of :email, with: EMAIL_REGEXP

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  has_secure_password

  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?

    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.authenticate(email, password)
    confirmed.find_by(email: email).try(:authenticate, password)
  end

end