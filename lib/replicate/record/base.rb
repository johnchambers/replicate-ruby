# frozen_string_literal: true

module Replicate
  module Record
    class Base
      def initialize(params)
        self.assign_attributes = params
      end

      def assign_attributes=(params)
        params = params.instance_variables_hash if params.is_a?(self.class)
        params.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def method_missing(method_name, *args, &block)
        if instance_variables.include? :"@#{method_name}"
          instance_variable_get "@#{method_name}"
        else
          super
        end
      end

      def instance_variables_hash
        Hash[instance_variables.map { |name| [name.to_s[1..-1], instance_variable_get(name)] } ]
      end

      def client
        @client ||= Replicate.client
      end
    end
  end
end
