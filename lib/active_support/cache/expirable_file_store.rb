module ActiveSupport
  module Cache
    # Improvements on the FileStore, to support expiration
    class ExpirableFileStore < ActiveSupport::Cache::FileStore

      def read(name, options = nil)
        val = super
        return nil unless val
        (metadata, realval) = val
        return nil if metadata[:expiration] && metadata[:expiration] < Time.now
        realval
      end

      # Rails.cache.write('test_key', 'test_value', :unless_exist => true, :expires_in => 15.minutes)
      def write(name, value, options = nil)
        storeval = [
                    {
                     :expiration => expiration(options)
                    },
                    value
                   ]
        super(name, storeval, options)
      end

      def exist?(name, options = nil)
        super && read(name, options)
      end

      private
        def expiration(options)
          if options
            if options[:expiration]
              options[:expiration].to_i
            elsif options[:expires_in]
              Time.now + options[:expires_in]
            end
          end
        end

    end
  end
end
