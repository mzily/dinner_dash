class Order < ActiveRecord::Base
  belongs_to :user
  
  has_many :order_items
  has_many :items, through: :order_items
  
  validates :status,
    presence: true,
    inclusion: { in: %w(ordered paid cancelled completed) }
  validates :total_price,
    presence: true
  validates :user_id,
    presence: true
  
  validate :has_item

  def has_item
    if items.to_a.count < 1
      errors.add(:items, "order must have at least one item")
    end
  end

  def purchaser_name
    user.full_name
  end
  
  def purchaser_email
    user.email
  end
  
  def total
    items.map{ |item| item.price }.inject(:+)
  end
  
  def quantity
    items.where(id: item.id).count
  end
end
