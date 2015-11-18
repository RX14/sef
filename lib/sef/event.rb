module SEF
  class Event
    # @param [SEF::EventSystem] event_system
    def initialize(event_system, event_data = {})
      @event_system = event_system
      @data         = event_data

      @finalized_keys = []
    end

    def [](key)
      @event_system.run_finalizer(self, key) unless @finalized_keys.include? key

      @data[key]
    end

    def get_mut(key)
      @data[key]
    end

    def []=(key, value)
      raise "Key has been finalized" if @finalized_keys.include? key
      @data[key] = value
    end

    def finalize(key)
      @finalized_keys << key
      @data[key].freeze
    end
  end
end
