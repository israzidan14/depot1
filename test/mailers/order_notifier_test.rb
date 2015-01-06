require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase

  setup do
    item = LineItem.new
    item.build_cart
    item.product = products(:ruby)
    @order = orders(:three)
    @order.line_items << item
 end

  test "received" do
    mail = OrderNotifier.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["contact@memoforever.com"], mail.from
    assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(@order)
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["contact@memoforever.com"], mail.from
    assert_match /<td>1&times;<\/td>\s*<td>Programming Ruby 1.9<\/td>/, mail.body.encoded
  end






end
