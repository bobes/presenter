require "helper"

class TestPresenter < Test::Unit::TestCase

  test "includes Core" do
    assert Presenter.constants.include?("Core")
  end
end
