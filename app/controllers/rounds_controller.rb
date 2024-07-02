class RoundsController < ApplicationController
  def create
    round.save
    flash[:errors] = round.errors.full_messages
    redirect_to fight_path(fight)
  end

  private

    def permitted_params = params.require(:round).permit(:enemy_id, :comment, puppet_names: [])

    def fight = 
      @fight ||= Fight.find(params[:fight_id])

    # TODO: for some reasons fight_id in this variant will be nil
    # @round ||= fight.rounds.new(permitted_params)
    def round
      @round ||= fight.rounds.new.tap do
        _1.assign_attributes(permitted_params)
      end
    end
end