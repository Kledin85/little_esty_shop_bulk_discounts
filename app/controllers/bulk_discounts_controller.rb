class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    @merchant = Merchant.find(params[:merchant_id])
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant.id)
    end
  end
  
  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def update
    bulk_discount = BulkDiscount.find(params[:id])
    
    if bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path()
    else
      redirect_to edit_merchant_bulk_discount_path
    end

  end
  
  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.permit(:id, :merchant_id, :percentage_discount, :quantity_threshold)
  end
end