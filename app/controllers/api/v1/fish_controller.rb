class Api::V1::FishController < ApplicationController
  def index
    date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @fishes = Fish.in_season_with_full_details(date)
    render json: @fishes
  end

  def show
    @fish = Fish.find(params[:id])
    render json: @fish.as_json(include: :fish_seasons, methods: :image_url)
  end

  private

  def fish_params
    params.require(:fish).permit(:name, :features, :nutrition, :origin)
  end
end
