# TODO: a most of the methods should be moved to a "view components".
class FramesController < ApplicationController
  PATTERN = {
    only: %i(fight_id comment),
    methods: %i(puppet_names),
    include: { enemy: { methods: %i(html_body html_title html_comment) } }.freeze
  }.freeze

  before_action :check_fight

  def show = render locals: { frames:, frame: prepared_frame(frame) }

  def index
    render locals: {
      replay: fight.as_json(only: %i(id score), methods: %i(band_name)),
      frames: fight.rounds.map { prepared_frame(_1) }
    }
  end

  private

    def check_fight = fight.score.present? || redirect_to(fight_path(fight))

    # TODO: yeah, it looks weird but #find will add extra sql request
    def fight
      @fight ||= Fight
        .eager_load(:band, rounds: [:puppets, :enemy])
        .where(id: params[:replay_id])
        .to_a.first.tap { raise ActiveRecord::RecordNotFound if _1.nil? }
    end
    
    def frame
      @frame ||= fight
        .rounds
        .find { _1[:enemy_id].eql?(params[:id].to_i) }
        .tap { raise ActiveRecord::RecordNotFound if _1.nil? }
    end

    def frames
      @rounds ||= fight.rounds.uniq(&:enemy_id).map do
        klass = [_1.win? ? :success : :failure]
        klass.push(:active) if _1.enemy_id.eql?(frame.enemy_id)
        _1.as_json(only: %i(fight_id enemy_id)).merge('class' => klass.join(' '))
      end
    end

    # TODO: I don't like the difference between enemy hash and frame open struct
    def prepared_frame(frame)
      frame
        .as_json(PATTERN)
        .merge(existing_puppets: prepared_puppets(frame))
        .then { OpenStruct.new(_1) }
    end

    def prepared_puppets(frame)
      existing_puppets[frame.enemy_id]
        .as_json(only: %i(name correct), methods: %i(html_body))
        .map { OpenStruct.new(_1) }
    end

    # TODO: enemy puppets N+1 difficult to solve because 
    # there are a two joins for the same table "puppets"
    def existing_puppets
      @existing_puppets ||= 
        Puppet.where(enemy_id: fight.rounds.select(:enemy_id)).group_by(&:enemy_id)
    end
end