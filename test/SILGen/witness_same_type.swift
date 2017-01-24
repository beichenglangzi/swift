// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-silgen %s | %FileCheck %s
// RUN: %target-swift-frontend -emit-ir %s

protocol Fooable {
  associatedtype Bar

  func foo<T: Fooable where T.Bar == Self.Bar>(x x: T) -> Self.Bar
}

struct X {}

// Ensure that the protocol witness for requirements with same-type constraints
// is set correctly. <rdar://problem/16369105>
// CHECK-LABEL: sil hidden [transparent] [thunk] @_T017witness_same_type3FooVAA7FooableAaaDP3foo3BarQzqd__1x_tAaDRd__AhGRtd__lFTW : $@convention(witness_method) <τ_0_0 where τ_0_0 : Fooable, τ_0_0.Bar == X> (@in τ_0_0, @in_guaranteed Foo) -> @out X
struct Foo: Fooable {
  typealias Bar = X

  func foo<T: Fooable where T.Bar == X>(x x: T) -> X { return X() }
}

// rdar://problem/19049566
// CHECK-LABEL: sil [transparent] [thunk] @_T017witness_same_type14LazySequenceOfVyxq_Gs0E0AAsADRz8Iterator_7ElementQZRs_r0_lsADP04makeG0{{[_0-9a-zA-Z]*}}FTW
public struct LazySequenceOf<SS : Sequence, A where SS.Iterator.Element == A> : Sequence {
  public func makeIterator() -> AnyIterator<A> { 
    var opt: AnyIterator<A>?
    return opt!
  }
	public subscript(i : Int) -> A { 
    get { 
      var opt: A?
      return opt!
    } 
  }
}
