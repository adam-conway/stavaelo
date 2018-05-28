class TournamentsController < ApplicationController
  def new
    @tournament = Tournament.new
    @segments = Segment.all
  end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      @tournament.user_tournaments.create(user_id: current_user.id)
      create_tournament_segments(params)
      flash[:success] = "Created a new tournament"
      redirect_to dashboard_path
    else
      flash[:error] = "Failed to create new tournament"
      render :new
    end
  end

  private
    def tournament_params
      params.require(:tournament).permit(:name)
    end

    def create_tournament_segments(params)
      params[:tournament][:segment_ids].each do |id|
        @tournament.tournament_segments.create(segment_id: id.to_i)
      end
    end
end
