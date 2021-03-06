require 'spec_helper'

module Daodalus
  module DSL
    describe Where do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      before do
        dao.insert('name'  => 'Terry',
                   'paws'  => 3,
                   'likes' => ['tuna', 'catnip'],
                   'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                               {'type' => 'wet', 'name' => 'whiskas'}])
      end

      it 'can test for equality' do
        dao.where(:name).eq('Terry').find.should have(1).item
      end

      it 'allows chaining of multiple clauses' do
        dao.where(:name).eq('Terry').and(:paws).eq(3).find_one.should be_some
      end

      it 'excludes documents that do not match' do
        dao.where(:name).eq('Terry').and(:paws).eq(77).find_one.should be_none
      end

      it 'can test for inequality' do
        dao.where(:name).ne('Jennifer').find_one.should be_some
        dao.where(:name).ne('Terry').find_one.should be_none
      end

      it 'implements #lt' do
        dao.where(:paws).lt(4).find_one.should be_some
        dao.where(:paws).lt(3).find_one.should be_none
      end

      it 'implements #gt' do
        dao.where(:paws).gt(4).find_one.should be_none
        dao.where(:paws).gt(2).find_one.should be_some
      end

      it 'implements #lte' do
        dao.where(:paws).lte(3).find_one.should be_some
        dao.where(:paws).lte(2).find_one.should be_none
      end

      it 'implements #gte' do
        dao.where(:paws).gte(3).find_one.should be_some
        dao.where(:paws).gte(4).find_one.should be_none
      end

      it 'implements #in' do
        dao.where(:paws).in(3, 5).find_one.should be_some
        dao.where(:paws).in(4, 1).find_one.should be_none
      end

      it 'implements #nin' do
        dao.where(:paws).nin(2, 5).find_one.should be_some
        dao.where(:paws).nin(4, 3).find_one.should be_none
      end

      it 'implements #all' do
        dao.where(:likes).all('catnip', 'tuna').find_one.should be_some
        dao.where(:likes).all('catnip', 'dogs').find_one.should be_none
      end

      it 'implements #size' do
        dao.where(:likes).size(2).find_one.should be_some
        dao.where(:likes).size(3).find_one.should be_none
      end

      it 'implements #exists' do
        dao.where(:paws).exists.find_one.should be_some
        dao.where(:horns).exists.find_one.should be_none
      end

      it 'can also check for non-existence' do
        dao.where(:horns).does_not_exist.find_one.should be_some
        dao.where(:paws).does_not_exist.find_one.should be_none
      end

      it 'implements #not' do
        dao.where(:paws).not.less_than(3).find_one.should be_some
        dao.where(:paws).not.eq(3).find_one.should be_none
      end

      it 'implements #any' do
        dao.where.any(
          dao.where(:likes).size(14),
          dao.where(:likes).eq('tuna'),
        ).find_one.should be_some

        dao.where.any(
          dao.where(:likes).size(14),
          dao.where(:likes).eq('dogs'),
        ).find_one.should be_none
      end

      it 'implements #none' do
        dao.where.none(
          dao.where(:likes).size(3),
          dao.where(:likes).eq('dogs'),
        ).find_one.should be_some

        dao.where.none(
          dao.where(:likes).size(7),
          dao.where(:likes).eq('catnip'),
        ).find_one.should be_none
      end

      it 'implements #elem_match' do
        dao.where(:foods).elem_match(
          dao.where(:type).eq(:wet).and(:name).eq('whiskas')
        ).find_one.should be_some

        dao.where(:foods).elem_match(
          dao.where(:type).eq(:dry).and(:name).eq('whiskas')
        ).find_one.should be_none
      end

      it 'can be chained with select clauses' do
        dao.where(:name).eq('Terry').select(:paws).find_one.value.fetch('paws').should eq 3
      end

      it 'can be passed a hash directly' do
        dao.where(name: 'Terry', paws: 3).find_one.should be_some
      end

    end
  end
end
