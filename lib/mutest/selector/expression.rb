module Mutest
  class Selector
    # Expression based test selector
    class Expression < self
      include Concord.new(:integration)

      def call _subject
        integration.all_tests
      end
    end
  end
end
