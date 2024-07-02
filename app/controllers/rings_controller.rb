class RingsController < ApplicationController
  PATTERN = {
    only: %i(id maximum_score treshold),
    methods: %i(band_name),
    include: { fights: { only: %i(id score), methods: %i(rounds_length) }.freeze }
  }.freeze

  def index = render locals: { rings: rings }

  private

    def rings = Ring.eager_load(fights: :rounds).as_json(PATTERN)
end
