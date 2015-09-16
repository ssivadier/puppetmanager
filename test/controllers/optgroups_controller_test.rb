require 'test_helper'

class OptgroupsControllerTest < ActionController::TestCase
  setup do
    @optgroup = optgroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:optgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create optgroup" do
    assert_difference('Optgroup.count') do
      post :create, optgroup: { name: @optgroup.name }
    end

    assert_redirected_to optgroup_path(assigns(:optgroup))
  end

  test "should show optgroup" do
    get :show, id: @optgroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @optgroup
    assert_response :success
  end

  test "should update optgroup" do
    patch :update, id: @optgroup, optgroup: { name: @optgroup.name }
    assert_redirected_to optgroup_path(assigns(:optgroup))
  end

  test "should destroy optgroup" do
    assert_difference('Optgroup.count', -1) do
      delete :destroy, id: @optgroup
    end

    assert_redirected_to optgroups_path
  end
end
