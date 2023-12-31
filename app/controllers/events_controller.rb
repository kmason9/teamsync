class EventsController < ApplicationController
  helper_method :health_status

  def index
    @team = current_user.team
    @events = Event.where(start_date: Time.now.beginning_of_month.beginning_of_week..)
    # start_date = params.fetch(:start_date, Date.today).to_date
    # @meetings = Event.where(start_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def show
    @team = current_user.team
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @team = Team.find(params[:team_id])
  end

  def create
    @event = Event.new(set_params)
    @team = current_user.team
    @event.team = @team
    @event.save
    if @event.save
      @event.player_ids = params[:event][:player_ids] || []
      @event.employee_ids = params[:event][:employee_ids] || []
      redirect_to team_event_path(@event.team_id, @event.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
    @team = current_user.team
    @event.team = @team
  end

  def update
    @event = Event.find(params[:id])
    @team = current_user.team
    @event.team = @team
    if @event.update(set_params)
      @event.player_ids = params[:event][:player_ids] || []
      @event.employee_ids = params[:event][:employee_ids] || []
      redirect_to team_event_path(@event.team_id, @event.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def health_status
    Player.all.map do |player|
      if player.health == "Available"
        "health-status available"
      elsif player.health == "Limited"
        "health-status limited"
      else
        "health-status injured"
      end
    end
  end

  private

  def set_params
    params.require(:event).permit(:title, :description, :location, :start_date, :end_date, :players, :event_type, :opposition)
  end
end
