ActiveAdmin.register Review do
  scope :all do |reviews|
    reviews.all
  end
  scope :new, default: true do |reviews|
    reviews.where(status: :unprocessed)
  end
  scope :processed do |reviews|
    reviews.where.not(status: :unprocessed)
  end

  index do
    selectable_column
    column :title
    column('Description') { |review| truncate(review.description, length: 75) }
    column('Book') { |review| review.book.title }
    column('User') { |review| review.user.email }
    column :status
    column :created_at
    column '' do |review|
      (link_to 'Approve', approve_admin_review_path(review), method: :put) + ' | ' +
        (link_to 'Reject', reject_admin_review_path(review), method: :put) + ' | ' +
        (link_to 'Unprocess', unprocess_admin_review_path(review), method: :put)
    end
  end

  member_action :approve, method: :put do
    review = Review.find(params[:id])
    review.approve!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Approved')
  end

  member_action :reject, method: :put do
    review = Review.find(params[:id])
    review.reject!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Rejected')
  end

  member_action :unprocess, method: :put do
    review = Review.find(params[:id])
    review.unprocess!
    redirect_back(fallback_location: admin_reviews_path, notice: 'Unprocessed')
  end
end