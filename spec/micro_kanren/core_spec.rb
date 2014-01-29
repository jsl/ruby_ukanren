require 'spec_helper'

describe MicroKanren::Core do
  include MicroKanren::Core
  include MicroKanren::MiniKanrenWrappers
  include MicroKanren::Lisp

  include MicroKanren::TestPrograms
  include MicroKanren::TestSupport

  it "second-set t1" do
    res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

    # The result should be  following the reference
    # implementation:
    # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L6

    #       ( ( ( #(0)    . 5 ) ) . 1  )
    exp = [ [ [ [ uvar(0) , 5 ] ] , 1  ] ]
    expected = ary_to_sexp(exp)

    lists_equal?(res, expected).must_equal true
  end

  it "second-set t2" do
    res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

    # Following reference implementation:
    # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L11
    cdr(res).must_be_nil
  end

  # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L13
  it "second-set t3" do
    res = car(a_and_b.call(empty_state))

    #     ( ( ( #(1)    . 5)    ( #(0)   . 7 ) )   . 2)
    exp = [ [ [ uvar(1) , 5], [ [uvar(0) , 7 ] ] ] , 2]
    sexp = ary_to_sexp(exp)

    lists_equal?(res, sexp).must_equal true
  end

  it "who cares" do
    res = take(1, call_fresh(-> (q) { fives.call(q) }).call(empty_state))

    #     ( ( ( ( #(0) . 5) ) . 1 ) )
    exp = [ [ [ [ uvar(0), 5] ] , 1 ] ]

    sexp = ary_to_sexp(exp)
    lists_equal?(res, sexp).must_equal true
  end

  it "take 2 a_and_b stream" do
    # Expected result in scheme:
    # ((((#(1) . 5) (#(0) . 7)) . 2)
    #  (((#(1) . 6) (#(0) . 7)) . 2))

    expected_ast_string =
      "(((([1] . 5) ([0] . 7)) . 2) ((([1] . 6) ([0] . 7)) . 2))"

    exp = [[[[ uvar(1), 5 ], [[ uvar(0), 7 ]]], 2],
           [[[[ uvar(1), 6 ], [[ uvar(0), 7 ]]], 2]]]

    # Sanity check the printed AST representation of our expression above
    # against what we expect in something closer to scheme.
    ast_to_s(ary_to_sexp(exp)).must_equal expected_ast_string

    res = take(2, a_and_b.call(empty_state))
    lists_equal?(res, ary_to_sexp(exp)).must_equal true
  end

  it "take_all a_and_b stream" do
    # Expected result in scheme:
    # ((((#(1) . 5) (#(0) . 7)) . 2)
    #  (((#(1) . 6) (#(0) . 7)) . 2))

    expected_ast_string =
      "(((([1] . 5) ([0] . 7)) . 2) ((([1] . 6) ([0] . 7)) . 2))"

    exp = [[[[ uvar(1), 5 ], [[ uvar(0), 7 ]]], 2],
           [[[[ uvar(1), 6 ], [[ uvar(0), 7 ]]], 2]]]

    ast_to_s(ary_to_sexp(exp)).must_equal expected_ast_string

    res = take_all(a_and_b.call(empty_state))
    lists_equal?(res, ary_to_sexp(exp)).must_equal true
  end

  it "ground appendo" do
    res = car(ground_appendo.call(empty_state).call)

    # Expected result in scheme:
    # (((#(2) b) (#(1)) (#(0) . a)) . 3)

    expected_ast_string =
      "((([2] b) ([1]) ([0] . a)) . 3)"

    exp = cons(cons(cons(uvar(2), cons(:b, nil)),
          cons(cons(uvar(1), nil), cons(cons(uvar(0), :a), nil))), 3)

    # Make sure our cons expression above is the same as the expected string.
    ast_to_s(exp).must_equal expected_ast_string

    # Finally compare the string representation of the result with the string
    # representation of our cons cell.
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

    expected = cons(
      cons(nil, cons(:'_.0', cons(:'_.0', nil))),
      cons(cons(cons(:'_.0', nil), cons(:'_.1', cons(cons(:'_.0', :'_.1'), nil))), nil)
    )

    ast_to_s(res).must_equal '((nil _.0 _.0) ((_.0) _.1 (_.0 . _.1)))'
  end

  it "reify-1st across appendo2" do
    res = map(method(:reify_1st).to_proc, take(2, call_appendo2.call(empty_state)))

    # Expected result in scheme:
    # ((() _.0 _.0) ((_.0) _.1 (_.0 . _.1)))

    expected = cons(
      cons(nil, cons(:'_.0', cons(:'_.0', nil))),
      cons(cons(cons(:'_.0', nil), cons(:'_.1', cons(cons(:'_.0', :'_.1'), nil))), nil)
    )

    ast_to_s(res).must_equal '((nil _.0 _.0) ((_.0) _.1 (_.0 . _.1)))'
  end

  it "#many non-ans" do
    res = take(1, many_non_ans.call(empty_state))
    ast_to_s(res).must_equal '(((([0] . 3)) . 1))'
  end
end
