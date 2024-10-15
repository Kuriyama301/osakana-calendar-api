class Api::V1::CalendarController < ApplicationController
  def fish_by_date
    date = Date.parse(params[:date])
    Rails.logger.debug "Searching for fish on date: #{date}"

    @fish = Fish.joins(:fish_seasons).where(
      '(fish_seasons.start_date <= ? AND fish_seasons.end_date >= ?) OR ' \
      '(fish_seasons.start_date > fish_seasons.end_date AND ' \
      '(fish_seasons.start_date <= ? OR fish_seasons.end_date >= ?))',
      date, date, date, date
    ).distinct

    Rails.logger.debug "Found #{@fish.count} fish for the date"

    if @fish.empty?
      render json: { message: "No fish found for the specified date." }, status: :not_found
    else
      render json: @fish, include: :fish_seasons
    end
  rescue ArgumentError
    render json: { error: "Invalid date format. Please use YYYY-MM-DD." }, status: :bad_request
  end
end
