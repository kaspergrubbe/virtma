module Virtma
  module Screens
    class BaseScreen
      attr_accessor :window_manager, :options

      def initialize(options)
        @changed = false
        @focused = false
        @window_manager = nil
        @options = options
      end

      def menu_title
        'Please implement me :-)'
      end

      def focus
        reset_changed
        focus!
        nil
      end

      def unfocus
        reset_changed
        unfocus!
        nil
      end

      def up
        reset_changed
        nil
      end

      def down
        reset_changed
        nil
      end

      def left
        reset_changed
        nil
      end

      def right
        reset_changed
        nil
      end

      def toggle
        reset_changed
        nil
      end

      def changed!
        @changed = true
      end

      def changed?
        @changed
      end

      def focused?
        @focused
      end

      private

      def focus!
        @focused = true
      end

      def unfocus!
        @focused = false
      end

      def reset_changed
        @changed = false
      end
    end
  end
end
