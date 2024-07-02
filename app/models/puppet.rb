class Puppet < ApplicationRecord
  self.primary_key = %i(enemy_id name)

  belongs_to :enemy, required: true

  validates :name, presence: true
  validates :body, presence: true

  scope :correct, -> { where correct: true }

  # TODO: attributes API with the casting?
  def html_body = markdown_to_html(body)
end
