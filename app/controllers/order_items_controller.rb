class OrderItemsController < ApplicationController
  before_action :order_item, only: [:update, :destroy]

  def create
    @order_item = @current_order.order_items.find_by(book_id: permited_params[:book_id])
    if @order_item
      @order_item.quantity += permited_params[:quantity].to_i
      @order_item.save!
    else
      @order_item = OrderItem.create(permited_params)
    end
  end

  def update
    @order_item.update(quantity: permited_params[:quantity])
  end

  def destroy
    @order_item.destroy
  end

  private

  def permited_params
    params.permit(:quantity, :book_id, :order_id)
  end

  def order_item
    @order_item = OrderItem.find(params[:id])
  end
end
