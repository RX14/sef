require "sef/event"
require "sef/consumer"
require "concurrent"

module SEF
  class EventSystem
    def initialize
      @consumers = []

      @pre_finalizers = Hash.new([]) # Default []
      @finalizer      = {}

      @done = {}

      @lock = Concurrent::ReadWriteLock.new
    end

    def consumers
      @lock.with_read_lock do
        @consumers.dup
      end
    end

    def register(finalizes = [], before_finalize = [], &proc)
      @lock.with_write_lock do
        consumer = Consumer.new(proc, finalizes, before_finalize)

        consumer.finalizes.each do |key|
          raise "Attempt to add duplicate finalizers for #{key}" unless @finalizer[key].nil?
          @finalizer[key] = consumer
        end

        consumer.before_finalize.each do |key|
          @pre_finalizers[key] << consumer
        end

        @consumers << consumer
      end
    end

    def post(event_hash = {})
      @lock.with_read_lock do
        event        = Event.new(self, event_hash)
        @done[event] = []

        @consumers.each { |consumer| do_consume(event, consumer) }

        @done.delete event
      end

      nil
    end

    def run_finalizer(event, key)
      @lock.with_read_lock do
        finalizer = @finalizer[key]
        raise "No finalizer for #{key}" if finalizer.nil?
        do_consume event, finalizer
      end
    end

    # @param [SEF::Consumer] consumer
    # @param [SEF::Event] event
    def do_consume(event, consumer)
      @lock.with_read_lock do
        return if @done[event].include? consumer

        consumer.finalizes.each do |key|
          @pre_finalizers[key].each { |c| do_consume(event, c) }
        end

        return if @done[event].include? consumer # Just in case

        @done[event] << consumer
        consumer.consume event
      end
    end

    private :do_consume
  end
end
