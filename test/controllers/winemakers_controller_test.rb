require 'test_helper'

class WinemakersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @winemaker = winemakers(:one)
  end

  test "should get index" do
    get winemakers_url
    assert_response :success
  end

  test "should get new" do
    get new_winemaker_url
    assert_response :success
  end

  test "should create winemaker" do
    assert_difference('Winemaker.count') do
      post winemakers_url, params: { winemaker: {  } }
    end

    assert_redirected_to winemaker_url(Winemaker.last)
  end

  test "should show winemaker" do
    get winemaker_url(@winemaker)
    assert_response :success
  end

  test "should get edit" do
    get edit_winemaker_url(@winemaker)
    assert_response :success
  end

  test "should update winemaker" do
    patch winemaker_url(@winemaker), params: { winemaker: {  } }
    assert_redirected_to winemaker_url(@winemaker)
  end

  test "should destroy winemaker" do
    assert_difference('Winemaker.count', -1) do
      delete winemaker_url(@winemaker)
    end

    assert_redirected_to winemakers_url
  end
end
