ActiveAdmin.register Review do
  actions :index, :show

  scope :all do |reviews|
    reviews.all
  end

  scope :new, default: true do |reviews|
    reviews.where(status: :unprocessed)
  end

  scope :processed do |reviews|
    reviews.where.not(status: :unprocessed)
  end

  filter :user, collection: User.pluck(:email, :id)
  filter :book
  filter :rating

  index do
    selectable_column
    column :title
    column('Book') { |review| review.book.title }
    column('User') { |review| review.user.email }
    column :status
    column :created_at
    column { |review| link_to 'Show', admin_review_path(review), method: :get }
  end

  show do
    panel 'Actions' do
      span { link_to 'Approve', approve_admin_review_path(review), method: :put }
      span { link_to 'Reject', reject_admin_review_path(review), method: :put }
      span { link_to 'Unprocess', unprocess_admin_review_path(review), method: :put }
    end
    default_main_content
  end

  member_action :approve, method: :put do
    Review.find(params[:id]).approve!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Approved')
  end

  member_action :reject, method: :put do
    Review.find(params[:id]).reject!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Rejected')
  end

  member_action :unprocess, method: :put do
    Review.find(params[:id]).unprocess!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Unprocessed')
  end
end
