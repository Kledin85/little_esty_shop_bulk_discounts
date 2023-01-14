require 'rails_helper'

RSpec.describe 'bulk discount show' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bd_1 = BulkDiscount.create!(percentage_discount: 20.00, quantity_threshold: 12, merchant_id: @merchant1.id)
    @bd_2 = BulkDiscount.create!(percentage_discount: 15.00, quantity_threshold: 3, merchant_id: @merchant1.id)
    @bd_3 = BulkDiscount.create!(percentage_discount: 25.00, quantity_threshold: 10, merchant_id: @merchant1.id)

    visit merchant_bulk_discount_path(@merchant1, @bd_1)
  end

  describe 'story 4' do
#     As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount
    it 'takes me to the show page' do 
      expect(page).to have_current_path(merchant_bulk_discount_path(@merchant1, @bd_1))
    end
    it 'shows that discounts quantity threshold and percentage' do
      expect(page).to have_content(@bd_1.percentage_discount)
      expect(page).to have_content(@bd_1.quantity_threshold)
    end
  end

  describe 'story 5' do
  #     As a merchant
  # When I visit my bulk discount show page
  # Then I see a link to edit the bulk discount
  # When I click this link
  # Then I am taken to a new page with a form to edit the discount
  # And I see that the discounts current attributes are pre-poluated in the form
  # When I change any/all of the information and click submit
  # Then I am redirected to the bulk discount's show page
  # And I see that the discount's attributes have been updated
    it 'has a link to edit the bulk discount' do
      expect(page).to have_link("Edit discount")
    end
    it 'takes me to the new page with a pre filled form to edit the discount' do
      click_link "Edit discount"
      
      expect(page).to have_current_path(edit_merchant_bulk_discount_path(@merchant1.id, @bd_1.id))
      
      expect(page).to have_field("Percentage discount", with: 20.0)
      expect(page).to have_field("Quantity threshold", with: 12)
    end
    
    it 'when any/all of the info is changed and the submit 
    button is clicked i am back on the bulk discounts 
    show page where I see the discounts attributes have been changed' do
      click_link "Edit discount"

      fill_in("Percentage discount", with: 55.0)
      fill_in("Quantity threshold", with: 10)

      click_button "Edit Discount"

      expect(page).to have_current_path(merchant_bulk_discount_path(@merchant1.id, @bd_1.id))
      
      expect(page).to have_content(55.0)
      expect(page).to have_content(10)

    end
  end
end