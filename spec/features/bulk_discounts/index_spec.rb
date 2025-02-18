require 'rails_helper'

RSpec.describe 'bulk discount index' do
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

    visit merchant_bulk_discounts_path(@merchant1)
  end

  describe 'story 2' do
  #     As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed
    it 'has a link to create a new discount' do
      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant1))

      expect(page).to have_link("create discount")
    end
    it 'can click the link and it takes me to a form to add a new bulk discount' do 
      click_link "create discount"

      expect(page).to have_current_path(new_merchant_bulk_discount_path(@merchant1))
      expect(find('form')).to have_field("Percentage discount")
      expect(find('form')).to have_field("Quantity threshold")
    end
    it 'redirects me to the bulk discount page when the form is filled with valid data' do 
      click_link "create discount"

      fill_in("Percentage discount", with: 35)
      fill_in("Quantity threshold", with: 7)
      click_button("Add Discount")
      
      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant1))
    end
    it 'displays my new bulk discount' do
      click_link "create discount"

      fill_in("Percentage discount", with: 35)
      fill_in("Quantity threshold", with: 7)
      click_button("Add Discount")

      expect(page).to have_content( 35 )
      expect(page).to have_content( 7 )
    end
  end

  describe 'story 3' do
#     As a merchant
# When I visit my bulk discounts index
# Then next to each bulk discount I see a link to delete it
# When I click this link
# Then I am redirected back to the bulk discounts index page
# And I no longer see the discount listed
    it 'has a link to delete a discount' do
      expect(page).to have_link("delete discount")

    end
    it 'redirects me back to the index page where i can no longer see the discount' do
      expect(page).to have_content(@bd_1.percentage_discount)
      expect(page).to have_content(@bd_1.quantity_threshold)
      
    
      
      within("##{@bd_1.id}") do
        click_link "delete discount"
      end
      
      
      expect(page).to_not have_content(@bd_1.percentage_discount)
      expect(page).to_not have_content(@bd_1.quantity_threshold)
    
    end
  end

  describe 'story 9' do
#     As a merchant
# When I visit the discounts index page
# I see a section with a header of "Upcoming Holidays"
# In this section the name and date of the next 3 upcoming US holidays are listed.
    it 'has a upcoming holidays header' do 
      expect(page).to have_content("Upcoming Holidays")
    end
    it 'has the next three holidays listed with the name and date' do 
      expect(page).to have_content("Presidents Day")
      expect(page).to have_content("2023-02-20")
      expect(page).to have_content("Good Friday")
      expect(page).to have_content("2023-04-07")
      expect(page).to have_content("Memorial Day")
      expect(page).to have_content("2023-05-29")
    end
  end
end