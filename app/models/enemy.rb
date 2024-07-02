class Enemy < ApplicationRecord
  belongs_to :band, required: true

  # TODO: actually enemy should be required to have minimum 1 correct puppet
  has_many :puppets, dependent: :destroy

  validates :title, presence: true
  validates :comment, presence: true
  validates :language, inclusion: { in: %w[en] }

  def hp = puppets.select(&:correct?).size 

  # TODO: attributes API with the casting?
  # I need add header because I don't want wrap title to <p>
  # since title can't be blank it's ok to write that in "the dummy" way
  def html_title = markdown_to_html("# #{title}")
  def html_body = markdown_to_html(body)
  def html_comment = markdown_to_html(comment)
end
