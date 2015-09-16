require 'test_helper'

class SystemrolesControllerTest < ActionController::TestCase
  setup do
    @systemrole = systemroles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:systemroles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create systemrole" do
    assert_difference('Systemrole.count') do
      post :create, systemrole: { gid: @systemrole.gid, name: @systemrole.name }
    end

    assert_redirected_to systemrole_path(assigns(:systemrole))
  end

  test "should show systemrole" do
    get :show, id: @systemrole
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @systemrole
    assert_response :success
  end

  test "should update systemrole" do
    patch :update, id: @systemrole, systemrole: { gid: @systemrole.gid, name: @systemrole.name }
    assert_redirected_to systemrole_path(assigns(:systemrole))
  end

  test "should destroy systemrole" do
    assert_difference('Systemrole.count', -1) do
      delete :destroy, id: @systemrole
    end

    assert_redirected_to systemroles_path
  end
end
