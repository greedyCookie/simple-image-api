# frozen_string_literal: true

class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  mount_uploader :content, ImageUploader

  embedded_in :user

  field :content
  field :height, type: Integer
  field :width, type: Integer

  validates :content, presence: true
  validates :height, presence: true
  validates :width, presence: true
end
