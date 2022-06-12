class ItemsController < ApplicationController
  
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_find

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end
  
  def show 
    if params[:user_id]
      user = find_user
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item
  end

  def create
    if params[:user_id]
      user = find_user
      new_item = user.items.create(item_params)
    else
      new_item = Item.create(item_params)
     end

    render json: new_item, status: :created
  end


  private

  def item_params
    params.permit(:name,:description,:price)
  end
  def find_user
    User.find(params[:user_id])
  end

  def rescue_not_find
    render json: {error: "Item not found"}, status: :not_found
  end


end
