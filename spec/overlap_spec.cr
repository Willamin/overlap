require "./spec_helper"

describe Overlap do
  test "that we can compare lists of ranges" do
    a = [1..2, 3..4, 5..6]
    b = [1..2, 3..4, 5..6]
    assert things_equate(a, b)

    c = [1..2, 3..4]
    d = [3..4, 1..2]
    assert things_equate(c, d)

    e = [1..4, 5..7]
    f = [1..7]
    assert !things_equate(e, f)
  end

  test "that we can make a super range from a list of ranges" do
    a = [1..2, 3..4, 5..6]
    assert (range(from: a) == 1..6)
  end

  test "the first step" do
    a = calc_part_1([1..4, 1..8])
    e = [Break.new, 1, 2, 3, 4, Break.new, 5, 6, 7, 8, Break.new]
    assert a == e
  end

  test "that our calculations work as expected" do
    a = calc([1..4, 1..8, 2..5, 6..10])
    e = [1, 2..4, 5, 6..8, 9..10]
    assert a == e
  end
end
