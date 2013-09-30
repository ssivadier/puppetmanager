require 'test_helper'

class PuppetModulesControllerTest < ActionController::TestCase
  setup do
    @puppet_module = puppet_modules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:puppet_modules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create puppet_module" do
    assert_difference('PuppetModule.count') do
      post :create, puppet_module: { name: @puppet_module.name, version: @puppet_module.version }
    end

    assert_redirected_to puppet_module_path(assigns(:puppet_module))
  end

  test "should show puppet_module" do
    get :show, id: @puppet_module
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @puppet_module
    assert_response :success
  end

  test "should update puppet_module" do
    patch :update, id: @puppet_module, puppet_module: { name: @puppet_module.name, version: @puppet_module.version }
    assert_redirected_to puppet_module_path(assigns(:puppet_module))
  end

  test "should destroy puppet_module" do
    assert_difference('PuppetModule.count', -1) do
      delete :destroy, id: @puppet_module
    end

    assert_redirected_to puppet_modules_path
  end
end
