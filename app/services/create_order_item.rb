class CreateOrderItem < Rectify::Command
  attr_reader :params, :order_item, :current_order

  def initialize(params:, current_order:)
    @params = params
    @current_order = current_order
    @order_item = @current_order.order_items.find_by(book_id: @params[:book_id]) if @current_order
  end

  def call
    create_order unless current_order
    order_item ? update_order_item_quantity : create_new_order_item
    broadcast(:ok)
  end

  private

  def create_order
    return @current_order = current_user.orders.create if user_signed_in?

    @current_order = Order.create
    cookies.signed[:order_id] = { value: current_order.id, expires: 1.month.from_now }
  end

  def update_order_item_quantity
    order_item.update(quantity: order_item.quantity + params[:quantity].to_i)
  end

  def create_new_order_item
    current_order.order_items.create(params)
  end
end
