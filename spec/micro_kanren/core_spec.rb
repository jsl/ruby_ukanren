require 'spec_helper'

describe MicroKanren::Core do

  include MicroKanren::Core
  include MicroKanren::MiniKanrenWrappers
  include MicroKanren::Lisp

  include MicroKanren::TestPrograms
  include MicroKanren::TestSupport

  # These tests follow the reference implementation in Scheme located at
  # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm

  it "second-set t1" do
    res = car(call_fresh(-> (q) { eq(q, 5) }).call(empty_state))
    ast_to_s(res).must_equal '((([0] . 5)) . 1)'
  end

  it "second-set t2" do
    res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)
    cdr(res).must_be_nil
  end

  it "second-set t3" do
    res = car(a_and_b.call(empty_state))
    ast_to_s(res).must_equal '((([1] . 5) ([0] . 7)) . 2)'
  end

  it "second set t3, take" do
    res = take(1, (a_and_b.call(empty_state)))
    ast_to_s(res).must_equal '(((([1] . 5) ([0] . 7)) . 2))'
  end

  it "second set t4" do
    res = car(cdr(a_and_b.call(empty_state)))
    ast_to_s(res).must_equal '((([1] . 6) ([0] . 7)) . 2)'
  end

  it "second set t5" do
    cdr(cdr(a_and_b.call(empty_state))).must_be_nil
  end

  it "who cares" do
    res = take(1, call_fresh(-> (q) { fives.call(q) }).call(empty_state))
    ast_to_s(res).must_equal '(((([0] . 5)) . 1))'
  end

  it "take 2 a_and_b stream" do
    res = take(2, a_and_b.call(empty_state))

    expected_ast_string =
      "(((([1] . 5) ([0] . 7)) . 2) ((([1] . 6) ([0] . 7)) . 2))"

    ast_to_s(res).must_equal expected_ast_string
  end

  it "take_all a_and_b stream" do
    res = take_all(a_and_b.call(empty_state))

    expected_ast_string =
      "(((([1] . 5) ([0] . 7)) . 2) ((([1] . 6) ([0] . 7)) . 2))"

    ast_to_s(res).must_equal expected_ast_string
  end

  it "ground appendo" do
    res = car(ground_appendo.call(empty_state).call)

    # Expected result in scheme:
    # (((#(2) b) (#(1)) (#(0) . a)) . 3)

    expected_ast_string =
      '((([2] b) ([1]) ([0] . a)) . 3)'

    ast_to_s(res).must_equal expected_ast_string
  end

  it "ground appendo2" do
    res = ast_to_s(car(ground_appendo2.call(empty_state).call))
    res.must_equal '((([2] b) ([1]) ([0] . a)) . 3)'
  end

  it "appendo" do
    res = ast_to_s(take(2, call_appendo.call(empty_state)))
    res.must_equal '(((([0] [1] [2] [3]) ([2] . [3]) ([1])) . 4) ((([0] [1] [2] [3]) ([2] . [6]) ([5]) ([3] [4] . [6]) ([1] [4] . [5])) . 7))'
  end

  it "appendo2" do
    res = ast_to_s(take(2, call_appendo2.call(empty_state)))
    res.must_equal '(((([0] [1] [2] [3]) ([2] . [3]) ([1])) . 4) ((([0] [1] [2] [3]) ([3] [4] . [6]) ([2] . [6]) ([5]) ([1] [4] . [5])) . 7))'
  end

  it "reify-1st across appendo" do
    res = map(method(:reify_1st).to_proc, take(2, call_appendo.call(empty_state)))

    # Expected result in scheme:
    # ((() _.0 _.0) ((_.0) _.1 (_.0 . _.1)))

    ast_to_s(res).must_equal '((nil _.0 _.0) ((_.0) _.1 (_.0 . _.1)))'
  end

  it "reify-1st across appendo2" do
    res = map(method(:reify_1st).to_proc, take(2, call_appendo2.call(empty_state)))
    ast_to_s(res).must_equal '((nil _.0 _.0) ((_.0) _.1 (_.0 . _.1)))'
  end

  it "#many non-ans" do
    res = take(1, many_non_ans.call(empty_state))
    ast_to_s(res).must_equal '(((([0] . 3)) . 1))'
  end
end
