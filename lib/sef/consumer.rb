module SEF
  class Consumer
    def initialize(proc, finalizes = [], before_finalize = [])
      raise "event handler must be able to respond to #call" unless proc.respond_to? :call
      @proc = proc

      @finalizes       = finalizes
      @before_finalize = before_finalize
    end

    def finalizes
      @finalizes.clone
    end

    def before_finalize
      @before_finalize.clone
    end

    def consume(event)
      @proc.call event
    end
  end
end
