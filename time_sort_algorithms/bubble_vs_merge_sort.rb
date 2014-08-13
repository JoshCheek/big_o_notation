# Examples:
# $ ruby bubble_vs_merge_sort.rb 100 1000 1000 10000
# $ ruby bubble_vs_merge_sort.rb 25 1000 500 30000



# Bubble Sort
def bubble_sort(array)
  array = array.dup
  array.length.times { |index| bubble_once array }
  array
end

def bubble_once(array)
  array.each_index.each_cons(2) do |prev, crnt|
    next if array[prev] < array[crnt]
    array[prev], array[crnt] = array[crnt], array[prev]
  end
end

# Merge Sort
def merge_sort(array)
  return array if array.size < 2
  mid_index    = array.size / 2
  left_sorted  = merge_sort(array[0...mid_index])
  right_sorted = merge_sort(array[mid_index..-1])
  merge(left_sorted, right_sorted)
end

def merge(ary1, ary2)
  merged = []
  merged << choose_array(ary1, ary2).shift while ary1.any? || ary2.any?
  merged
end

def choose_array(ary1, ary2)
  return ary2 if ary1.empty?
  return ary1 if ary2.empty?
  return ary1 if ary1.first < ary2.first
  return ary2
end


if $0 !~ /rspec/
  bubble_sort_iteration_size = (ARGV[0] || 100  ).to_i
  bubble_sort_max            = (ARGV[1] || 1000 ).to_i
  merge_sort_iteration_size  = (ARGV[2] || 1000 ).to_i
  merge_sort_max             = (ARGV[3] || 10000).to_i

  def time(&block)
    start_time = Time.now
    block.call
    (Time.now - start_time) * 1000
  end

  bubble_sort_data = []
  merge_sort_data  = []

  puts "Bubble Sort:"
  arrays_to_sort = 0.step(by: bubble_sort_iteration_size, to: bubble_sort_max).map do |n|
    array        = n.times.to_a.shuffle
    milliseconds = time { bubble_sort array }.to_i
    bubble_sort_data << [n, milliseconds]
    printf "  %d - %d ms\n", n, milliseconds
  end

  puts "Merge Sort:"
  0.step(by: merge_sort_iteration_size, to: merge_sort_max).map do |n|
    array        = n.times.to_a.shuffle
    milliseconds = time { merge_sort array }.to_i
    merge_sort_data << [n, milliseconds]
    printf "  %d - %d ms\n", array.size, milliseconds
  end

  File.write 'bubble_sort_data.txt', bubble_sort_data.map { |n, ms| "#{n},#{ms}" }.join("\n")
  File.write 'merge_sort_data.txt',  merge_sort_data.map  { |n, ms| "#{n},#{ms}" }.join("\n")


else
  RSpec.shared_examples "a sort algorithm" do
    it 'sorts shit' do
      expect(sort []).to eq []
      expect(sort [1]).to eq [1]
      expect(sort [1, 2]).to eq [1, 2]
      expect(sort [2, 1]).to eq [1, 2]
      expect(sort [1, 2, 3]).to eq [1, 2, 3]
      expect(sort [1, 3, 2]).to eq [1, 2, 3]
      expect(sort [2, 1, 3]).to eq [1, 2, 3]
      expect(sort [2, 3, 1]).to eq [1, 2, 3]
      expect(sort [3, 1, 2]).to eq [1, 2, 3]
      expect(sort [3, 2, 1]).to eq [1, 2, 3]
      expect(sort [6, 5, 4, 3, 8, 10, 7, 9, 1, 2]).to eq [*1..10]
    end

    it 'doesn\'t mutate the original array' do
      ary = [2, 1]
      sort ary
      expect(ary).to eq [2, 1]
    end
  end

  RSpec.describe 'bubble_sort' do
    it_behaves_like 'a sort algorithm' do
      alias sort bubble_sort
    end
  end

  RSpec.describe 'merge_sort' do
    it_behaves_like 'a sort algorithm' do
      alias sort merge_sort
    end
  end
end
