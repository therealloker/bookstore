class OrderItemsController < ApplicationController
  before_action :order_item, only: [:update, :destroy]

  def create
    @order_item = OrderItem.find_by(book_id: params[:book_id], order_id: params[:order_id])
    if @order_item
      @order_item.quantity += params[:quantity].to_i
      @order_item.save
    else
      @order_item = OrderItem.create(permited_params)
    end
  end

  def update
    @order_item.update(quantity: params[:quantity])
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
