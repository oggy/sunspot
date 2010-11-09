require File.join(File.dirname(__FILE__), 'spec_helper')

shared_examples_for "grouping query" do
  it 'turns on grouping' do
    search Post do
      group_by :blog_id
    end
    connection.should have_last_search_with(:group => true)
  end

  it 'sets the grouping fields from arguments' do
    search Post do
      group_by :blog_id, :title
    end
    connection.should have_last_search_including(:'group.field', :blog_id, :title)
  end

  it 'sets the grouping fields from the block' do
    search Post do
      group_by do
        field :blog_id
        field :title
      end
    end
    connection.should have_last_search_including(:'group.field', :blog_id, :title)
  end

  it 'sets the grouping functions from the block' do
    search Post do
      group_by do
        function { sum(:average_rating, 10) }
      end
    end
    connection.should have_last_search_including(:'group.func', 'sum(average_rating_ft,10)')
  end

  it 'limits each group to the group limit' do
    search Post do
      group_by :blog_id do
        limit 20
      end
    end
    connection.should have_last_search_with(:'group.limit' => 20)
  end

  it 'offsets the documents in each group by the given offset' do
    search Post do
      group_by :blog_id do
        offset 100
      end
    end
    connection.should have_last_search_with(:'group.offset' => 100)
  end

  it 'sorts the documents in each group by the given group sort' do
    search Post do
      group_by :blog_id do
        order_by :average_rating, :desc
      end
    end
    connection.should have_last_search_with(:'group.sort' => 'average_rating_ft desc')
  end
end
