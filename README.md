# DAODALUS

### Construct complex MongoDB queries, updates and aggregations.

##### Examples:

    #!ruby
    class CatDAO
      extend Daodalus::DSL
      target :animals, :cats # or overide `connection` to supply your own

      def self.example_find
        select(:name).where(:paws).less_than(4).find
      end

      def self.example_find_one
        where(:collar_id).eq("aochc986").find_one
      end

      def self.example_update
        set(:stray, true).where(:address).does_not_exist.update
      end

      def self.example_find_and_modify
        dec(:lives).
          push(:names, "Kitty").
          where(:stray).eq(true).
          and(:cuteness).gt(8).
          find_and_modify(new: true)
      end

      def self.example_remove
        where(:lives).eq(0).remove
      end

      def self.example_aggregation
        match(:lives).gt(3).
          and(:address).exists.
          unwind(:favourite_foods).
          group(:favourite_foods).
          min(:paws).as(:min_paws).
          sort(:_id).
          limit(10).
          project(:_id).as(:food).and(:min_paws).
          aggregate
      end
    end
