class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants



  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  
  def discounted_revenue
    #what unit prices? prices where the quantity is greater than the bulk discount threshold
    invoice_items.joins(item: {merchant: :bulk_discounts})
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percentage_discount / 100)) AS  max')
    .group(:id)
    .sum(&:max)
  end

  def revenue_with_discount
    total_revenue - discounted_revenue
  end

end
