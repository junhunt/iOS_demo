//
//  PercentageCalculatorTests.swift
//  PercentageCalculatorTests
//
//  Created by Maxime Defauw on 03/02/16.
//  Copyright © 2016 App Coda. All rights reserved.
//

import XCTest
@testable import PercentageCalculator
import CoreData

class PercentageCalculatorTests: XCTestCase {
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //测试界面更新函数的性能
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            //通过访问 viewController的 view 属性来触发 viewController初始化,从而接下来方法的调用不会崩溃
            let _ = self.vc.view
            
            self.vc.updateLabels(Float(11.1), Float(22.2), Float(33.3))
        }
    }
    
    //测试计算百分比函数
    func testPercentageCalculator() {
        let p = vc.percentage(value: 50, percentage: 50)
        
        //表达式为真则让测试通过，否则认为测试失败。
        XCTAssert(p == 25)
    }
    
    //测试界面更新函数
    func testLabelValuesShowedProperly() {
        /*在 storyboard 文件中创建了这些 labels 的，因此只有当 view 被加载之后（loaded）它们才会被初始化，然而由于对单元测试来说 loadView() 方法不会被触发，所以这些 labels 没有被创建，只能是 nil。一种可能的方法是通过调用 vc.loadView() 来解决，但是 Apple 在它的文档中并不推荐你这么做，因为当已经被加载的对象又被加载一次的话可能会引起内存泄露。
        正确的方法是你应该先访问一下 vc 的 view 这个属性，这会让 vc 反过来触发所有相应的方法*/
        let _ = vc.view
        
        vc.updateLabels(80, 50, 40)
        
        XCTAssert(vc.numberLabel.text == "80.0", "numberLabel doesn't show the right text")
        XCTAssert(vc.percentageLabel.text == "50.0%", "percentageLabel doesn't show the right text")
        XCTAssert(vc.resultLabel.text == "40.0", "resultLabel doesn't show the right text")
    }
    
    //常用 XCTest 断言
    func testAssert(){
        //最基本的断言
        XCTAssert(1 == 1, "等式两边的表达式应该是相等的")
        //Bool 断言测试
        let isTrue:Bool = true
        let isFalse:Bool = false
        XCTAssertTrue(isTrue, "本表达式应该是 true")
        XCTAssertFalse(isFalse, "本表达式应该是 false")
        //相等测试
        let x = 1
        let y = 2
        let z = 1
        XCTAssertEqual(x, z, "这两个表达式应该是相等的")
        XCTAssertNotEqual(x, y, "这两个表达式应该是不相等的")
        //Nil 测试
        let isNil:Bool? = nil
        let noNil = x
        XCTAssertNil(isNil, "本表达式应该是 nil")
        XCTAssertNotNil(noNil, "本表达式应该是非 nil")
        //无条件失败断言
        //XCTFail()
    }
    
    //XCTestExpectation 异步测试
    func testAsynchronousURLConnection(){
        let url = URL(string: "http://httpbin.org/")!
        //首先是创建一个 expection
        let urlExpectation = expectation(description: "GET\(url)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            //在异步测试剩下的回调函数中告诉 expectation 条件已经满足,如果测试中有多个 expectation, 则每个都必须 fulfill, 否则测试不通过
            urlExpectation.fulfill()
            XCTAssertNil(error, "error应该为空")
            XCTAssertNotNil(data, "返回数据不应该为空")
            
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                XCTAssertEqual(httpResponse.url, url, "HTTPResponse 的 URL应该和请求 URL一致")
                XCTAssertEqual(httpResponse.statusCode, 200, "HTTPResponse 的状态码应该是200")
                XCTAssertEqual(httpResponse.mimeType!, "text/html", "HTTPResponse 内容应该是text/html")
            }else{
                XCTFail("返回内容不是 NSHTTPURLResponse 类型")
            }
        }
        task.resume()
        //最后,指定等待超时的时间和指定时间内条件无法满足时执行的闭包
        waitForExpectations(timeout: (task.originalRequest?.timeoutInterval)!, handler: { error in
            task.cancel()
        })
    }
    
    //Mock数据。很多开源库支持 Mock 和 Stub,但都严重依赖于 Object-C运行时.但 Swift 中,类可以定义在一个类的方法中,这一特点允许 mock 自包含的对象。只要定义一个mock类，然后 override 必要的方法.
    func testFetchRequestWithMockedManagedObjectContext() {
        class MockNSManagedObjectContext:NSManagedObjectContext {
            override func fetch(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
                return [["name":"张三", "email":"zhangsan@icloud.com"]]
            }
        }
        let mockContext = MockNSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email ENDSWITh[cd] %@", "icloud.com")
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        var results:[AnyObject]? = nil
        do {
            try results = mockContext.fetch(fetchRequest)
        } catch {
            results = nil
        }
        XCTAssertEqual(results!.count, 1, "fetch request 应该只返回一个结构")
        
        let result = results![0] as! [String:String]
        XCTAssertEqual(result["name"]! as String, "张三", "name 应该是张三")
        XCTAssertEqual(result["email"]! as String, "zhangsan@icloud.com", "email 应该是 zhangsan@icloud.com")
    }
}
