require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  
  fixtures :products

  # 1) A user goes to the index page. 2) They select a product, adding it to their
  # cart, 3) and check out, 4) filling in their details on the checkout form. 4) When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.


 test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    #1
    get "/"
    assert_response :success
    assert_template "index"
    
    #2
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success 
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    #3
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    post_via_redirect "/orders",
                      order: { name:     "Dave Thomas",
                               address:  "123 The Street",
                               email:    "dave@example.com",
                               pay_type: "Check" }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    #4
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Dave Thomas",      order.name
    assert_equal "123 The Street",   order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check",            order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Wagner Renzi <contact@memoforever.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end


  test "sensitive data should requires login" do
    delete '/logout'
    get '/admin'
    assert_redirected_to %r(/login)
  end




end
