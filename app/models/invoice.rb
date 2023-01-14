class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def applied_discounts
    invoice_items.where('quantity >= ?', "merchants.best_discount" )
  end

  def discounted_revenue
    total_rev = total_revenue
    binding.p÷ry
  end
end
