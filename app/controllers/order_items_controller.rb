class OrderItemsController < ApplicationController
  before_action :order_item, only: %i[update destroy]

  def create
    CreateOrderItem.call(params: permited_params, current_order: current_order) do
      on(:ok) { render :create }
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
    params.permit(:quantity, :book_id)
  end

  def order_item
    @order_item = OrderItem.find(params[:id])
  end
end
