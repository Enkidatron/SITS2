require 'test_helper'

class ShipsControllerTest < ActionController::TestCase
  setup do
    @ship = ships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ship" do
    assert_difference('Ship.count') do
      post :create, ship: { name: @ship.name, notes: @ship.notes, pivot: @ship.pivot, roll: @ship.roll, ship_class: @ship.ship_class, user_id: @ship.user_id }
    end

    assert_redirected_to ship_path(assigns(:ship))
  end

  test "should show ship" do
    get :show, id: @ship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ship
    assert_response :success
  end

  test "should update ship" do
    patch :update, id: @ship, ship: { name: @ship.name, notes: @ship.notes, pivot: @ship.pivot, roll: @ship.roll, ship_class: @ship.ship_class, user_id: @ship.user_id }
    assert_redirected_to ship_path(assigns(:ship))
  end

  test "should destroy ship" do
    assert_difference('Ship.count', -1) do
      delete :destroy, id: @ship
    end

    assert_redirected_to ships_path
  end
end
