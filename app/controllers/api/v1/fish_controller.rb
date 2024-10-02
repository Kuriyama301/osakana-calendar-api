class Api::V1::FishController < ApplicationController
  def index
    @fishes = Fish.all
    @fishes = @fishes.where(season: params[:season]) if params[:season]
    render json: @fishes
  end

  def show
    @fish = Fish.find(params[:id])
    render json: @fish
  end

  # 今後の実装で管理画面を追加する

  # def create
  #   @fish = Fish.new(fish_params)
  #   if @fish.save
  #     render json: @fish, status: :created
  #   else
  #     render json: @fish.errors, status: :unprocessable_entity
  #   end
  # end

  # def update
  #   @fish = Fish.find(params[:id])
  #   if @fish.update(fish_params)
  #     render json: @fish
  #   else
  #     render json: @fish.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @fish = Fish.find(params[:id])
  #   @fish.destroy
  #   head :no_content
  # end

  private

  # def fish_params
  #   params.require(:fish).permit(:name, :description, :image_url, :season)
  # end
end
