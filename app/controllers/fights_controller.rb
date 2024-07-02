class FightsController < ApplicationController
  def create
    if fight.save
      redirect_to fight_path(fight)
    else
      # TODO: add errors to layout
      flash[:errors] = fight.errors.full_messages
      redirect_to rings_path
    end
  end

  def show
    # fight.score? will return false for 0 win rounds
    if fight.score.present?
      redirect_to replay_path(fight)
    else
      render locals: { 
        coursor: fight.rounds_length.next,
        maximum_score: fight.maximum_score,
        fight: fight,
        round: fight.rounds.new(enemy:),
        enemy: enemy.as_json(methods: %i(html_title html_body hp)),
        puppets: enemy.puppets 
      }  
    end
  end

  private

    def permitted_params = params.require(:fight).permit(:ring_id)

    def fight
      @fight ||= params[:id] ? existing_fight : new_fight
    end

    def new_fight = Fight.new(permitted_params)
    def existing_fight = Fight.eager_load(:ring).find(params[:id])

    def enemy
      @enemy ||= fight.current_enemy
    end
end
