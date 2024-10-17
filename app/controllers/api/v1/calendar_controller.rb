class Api::V1::CalendarController < ApplicationController
  def fish_by_date
    date = Date.parse(params[:date])
    @fish = Fish.in_season_on(date).includes(:fish_seasons)

    if @fish.empty?
      render json: { message: "No fish found for the specified date." }, status: :not_found
    else
      render json: @fish.as_json(include: :fish_seasons, methods: :image_url)
    end
  rescue ArgumentError
    render json: { error: "Invalid date format. Please use YYYY-MM-DD." }, status: :bad_request
  rescue StandardError => e
    Rails.logger.error "Error in fish_by_date: #{e.message}"
    render json: { error: "An unexpected error occurred." }, status: :internal_server_error
  end
end
