class Api::V1::CalendarController < ApplicationController
  def fish_by_date
    date = Date.parse(params[:date])
    @fishes = Fish.in_season_with_details(date)
    render json: @fishes
  end
end