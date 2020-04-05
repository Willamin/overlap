# TODO: Write documentation for `Overlap`
module Overlap
  VERSION = "0.1.0"
end

class Identity(T)
  @just : T

  def initialize(@just : T); end

  def map
    o = yield @just
    Identity(typeof(o)).new(o)
  end

  def unwrap : T
    @just
  end
end

def validate(a : A(R(I, I))) : Bool
  lowest = a.map(&.begin).min
  highest = a.map(&.end).max

  (lowest..highest)
    .map { |x| a.compact_map { |r| r.includes?(x) ? r : nil }.size }
    .all? { |x| x == 1 }
end

struct Break; end

alias I = Int32
alias R = Range
alias A = Array
alias B = Break

def things_equate(a : A(R(I, I)), b : A(R(I, I))) : Bool
  a.map(&.to_a).uniq.sort == b.map(&.to_a).uniq.sort
end

def range(from : A(R(I, I)))
  (from.map(&.begin).min)..(from.map(&.end).max)
end

def calc_part_1(a)
  previous_set = A(R(I, I)).new
  final_set = A(I | B).new

  range(from: a)
    .to_a
    .each do |i|
      this_set = A(R(I, I)).new

      a.each do |rs|
        if rs.includes?(i)
          this_set << rs
          this_set = this_set.uniq
        end
      end

      if things_equate(this_set, previous_set)
        final_set << i
      else
        final_set << B.new
        final_set << i
        previous_set = this_set
      end
    end

  final_set << B.new
end

def calc_part_2(a)
  final_ranges = A(R(I, I)).new
  this_begin : I? = nil
  this_end : I? = nil
  previous_was_break = false

  a.each do |i|
    if i.is_a?(B)
      if b = this_begin
        if e = this_end
          final_ranges << (b..e)
          b = nil
          e = nil
        end
      end
      previous_was_break = true
    else
      if previous_was_break
        this_begin = i.as?(I)
      end
      this_end = i.as?(I)
      previous_was_break = false
    end
  end

  final_ranges
end

def calc_part_3(a)
  a.map { |r| r.begin == r.end ? r.begin : r }
end

def calc(a)
  Identity.new(a)
    .map { |x| calc_part_1(x) }
    .map { |x| calc_part_2(x) }
    .map { |x| calc_part_3(x) }
    .unwrap
end

# puts("given this input: #{[1..4, 1..8, 2..5, 6..10]}")
# puts("this is the output: #{calc([1..4, 1..8, 2..5, 6..10])}")
