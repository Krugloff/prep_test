class ReplaysController < ApplicationController
  before_action :check_fight

  def show
    render locals: {
      fight: fight.as_json(only: %i(id score), methods: %i(band_name)).merge('frames' => frames)
    }
  end

  private

    def check_fight = fight.score.present? || redirect_to(fight_path(fight))

    # TODO: yeah, it looks weird but #find will add extra sql request
    def fight
      @fight ||= Fight
        .eager_load(:band, rounds: %i(enemy puppets))
        .where(id: params[:id])
        .to_a.first.tap { raise ActiveRecord::RecordNotFound if _1.nil? }
    end

    def frames
      @frames ||= fight.rounds.uniq(&:enemy_id).map do
        _1.as_json(only: %i(fight_id enemy_id)).merge('class' => _1.win? ? :success : :failure)
      end
    end
end