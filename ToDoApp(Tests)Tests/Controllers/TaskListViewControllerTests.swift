//
//  TaskListViewControllerTests.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 14.11.2022.
//

import XCTest
@testable import ToDoApp_Tests_

final class TaskListViewControllerTests: XCTestCase {

    var sut: TaskListViewController!
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testWhenViewIsLoadedTableViewNotNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLOadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider
        )
    }
    
    func testTaskListVCHasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem, let action = newTaskButton.action else { return NewTaskViewController()}
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        return newTaskViewController
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()
        
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
    
    func testSharesSameTaskManagerWithNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()

        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func testWhenViewAppearedTableViewReloaded() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager!.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectRow notification"), object: nil) { notification -> Bool in
            
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {return false}
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView?(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavController = MockNamigationController(rootViewController: sut)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = mockNavController
        
        sut.loadViewIfNeeded()
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task1)
        sut.dataProvider.taskManager?.add(task: task2)
        NotificationCenter.default.post(name: NSNotification.Name("DidSelectRow notification"), object: self, userInfo: ["task" : task2])

        guard let detailViewController = mockNavController.pushedViewController as? DetailViewController else {XCTFail(); return}
        
        detailViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task2)
    }
    
    
}


extension TaskListViewControllerTests {
    
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
    
}

extension TaskListViewControllerTests {
    
    class MockNamigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            
            super.pushViewController(viewController, animated: true)
        }
    }
    
    
}
