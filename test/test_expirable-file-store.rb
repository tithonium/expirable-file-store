require 'helper'

class TestExpirableFileStore < Test::Unit::TestCase
  should "be able to lookup_store" do
    assert_not_nil ActiveSupport::Cache.lookup_store(:expirable_file_store, File.join('.', 'tmp', 'cache'))
  end
end
