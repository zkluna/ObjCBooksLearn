//
//  main.swift
//  Tips
//
//  Created by zl on 2019/6/11.
//  Copyright © 2019 youtil. All rights reserved.
//

import Foundation

/*
/** Currying */
//func addTo(_ adder: Int) -> (Int) -> Int {
//    return { num in
//        return num + adder
//    }
//}
//let addTwo = addTo(2)
//let result = addTwo(6)
//print(result)

/**
protocol TargetAction {
    func performAction()
}
struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}
enum ControlEvent {
    case TouchUpInside
    case ValueChanged
}
class Control {
    var actions = [ControlEvent: TargetAction]()
    func setTarget<T: AnyObject>(target: T, action: @escaping (T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}
*/

/** Sequence */

class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    var array: [Element]
    var currentIndex = 0
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        } else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}
struct ReverseSequence<T>: Sequence {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }
    typealias Iterator = ReverseIterator
    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}
//let arr = [0, 1, 2, 3, 4]
//for i in ReverseSequence(array: arr) {
//    print("Index \(i) is \(arr[i])")
//}

/** 多元数 */
func swapMe2<T>(a: inout T, b: inout T) {
    (a, b) = (b, a)
}

/** @autoclosure ?? */
func logIfTrue(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("True")
    } else {
        print("false")
    }
}
//logIfTrue(2 > 1)

/** @escaping */
func doWork(block: @escaping ()->()) {
    DispatchQueue.main.async {
        block()
    }
}

class S {
    var foo = "foo"
    func method3() {
        doWork {
            [weak self] in
            print(self?.foo ?? "nil")
        }
        foo = "bar"
    }
}

/** Optional Chaining */
class Toy {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class Pet { var toy: Toy? }
class Child { var pet: Pet? }
extension Toy {
    func play() {}
}
var xiaoming = Child()
let palyClosure = {(child: Child) -> ()? in child.pet?.toy?.play()}
//if let _: () = palyClosure(xiaoming) {
//    print("好开心~")
//} else {
//    print("没有玩具可以玩 :(")
//}

/** 操作符 */
precedencegroup DotProductPrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}
infix operator +*: DotProductPrecedence

/** 字面量表达式 */
enum MyBool: Int {
    case myTrue, myFalse
}
extension MyBool : ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .myTrue : .myFalse
    }
}
class Person: ExpressibleByStringLiteral {
    let name: String
    init(name value: String) {
        self.name = value
    }
    required convenience init(stringLiteral value: String) {
        self.init(name: value)
    }
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    required convenience init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
}
let p: Person = "xiaoming"

/** 下标 */
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        set {
            for(index, i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
//var temArr = [1, 2, 3, 4, 5]
//print(temArr[[0, 2, 3]])
//print(temArr[1])

/** 方法嵌套 */

/** 命名空间 */

/** typealias */
protocol Cat { func catFun() }
protocol Dog { func dogFun() }
typealias Pat = Cat & Dog

/** associatedtype */
protocol Food { }
protocol Animal {
    associatedtype F
    func eat(_ food: F)
}
struct Meat: Food { }
struct Grass: Food { }
struct Tiger: Animal {
    typealias F = Meat
    func eat(_ food: Meat) {
        print("eat \(food)")
    }
}
struct Sheep: Animal {
    func eat(_ food: Grass) {
        print("eat \(food)")
    }
}
func isDangerous<T: Animal>(animal: T) -> Bool {
    if animal is Tiger {
        return true
    } else {
        return false
    }
}
*/

/**  进阶  */

//var x = [1, 2, 3]
//var y = x
//y.append(4)
//print(y)
//print(x)

//let a = NSMutableArray(array: [1, 2, 3])
//let b: NSArray = a
//a.insert(4, at: 3)
//print(a)
//print(b)
//print( (1..<10).map{ $0 * $0 }.filter{$0 % 2 == 0} )

//let suits = ["♠", "♥", "♣", "♦"]
//let ranks = ["J","Q","K","A"]
//
//let subResult = ranks.map{ rank in
//    ("♠", rank)
//}
//print(subResult)
//
//let result = suits.flatMap { suit in
//    ranks.map{ rank in
//        (suit, rank)
//    }
//}
//print(result)

/** 可变参数函数 */
func sum(input: Int...) -> Int {
    return input.reduce(0, +)
}
func myFunc(numbers: Int..., string: String) {
    numbers.forEach {
        for i in 0..<$0 {
            print("\(i + 1):\(string)")
        }
    }
}

/** 初始化方法顺序 */
/** 初始化返回nil */
/** 多类型和容器 */
/** default参数 */
/** 正则表达式 */
struct RegexHelper {
    let regex: NSRegularExpression
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}
let mainPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
let matcher: RegexHelper
do {
    matcher = try RegexHelper(mainPattern)
}
let mayBeMailAddress = "onev@onevcat.com"
if matcher.match(mayBeMailAddress) {
    print("有效的邮箱地址")
}
