module Daodalus
  module DSL
    module Queries

      def find(options = {})
        dao.find(query.wheres).select(query.selects)
      end

      def find_one
        Option[dao.find(query.wheres).select(query.selects).one]
      end

      def remove(options = {})
        dao.find(query.wheres).remove_all
      end

      def where field=nil
        if field.is_a? Hash
          Where.new(dao, query.where(field), nil)
        else
          Where.new(dao, query, field)
        end
      end

      def select *fields
        Select.new(dao, query, fields)
      end

    end
  end
end
