//
//  ALKConversationViewControllerSnapshotTests.swift
//  ApplozicSwiftDemoTests
//
//  Created by Shivam Pokhriyal on 24/10/18.
//  Copyright © 2018 Applozic. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots
import Applozic
@testable import ApplozicSwift

class ALKConversationViewControllerSnapshotTests: QuickSpec{
    
    override func spec() {
        
        describe("Test Conversation VC") {
            
            var conversationVC: ALKConversationViewController!
            var navigationController: UINavigationController!
            
            beforeEach {
                let contactId = "testExample"
                conversationVC = ALKConversationViewController(configuration: ALKConfiguration())
                let convVM = ALKConversationViewModelMock(contactId: contactId, channelKey: nil, localizedStringFileName: ALKConfiguration().localizedStringFileName)
                
                let firstMessage = MockMessage().message
                firstMessage.message = "first message"
                let secondMessage = MockMessage().message
                secondMessage.message = "second message"
                let thirdMessage = MockMessage().message
                thirdMessage.type = "4"
                let fourthMessage = MockMessage().message
                fourthMessage.type = "4"
                
                let testBundle = Bundle(for: ALKConversationViewControllerSnapshotTests.self)
                let (firstImageMessage, _) = convVM.send(photo: UIImage(named: "testImage.png", in: testBundle, compatibleWith: nil)!, metadata :nil)
                let date = Date(timeIntervalSince1970: -123456789.0).timeIntervalSince1970*1000
                firstImageMessage?.createdAtTime = NSNumber(value: date)
                firstImageMessage?.status = NSNumber(integerLiteral: Int(SENT.rawValue))
                firstImageMessage?.message = "Test caption"
                let (secondImageMessage, _) = convVM.send(photo: UIImage(named: "testImage.png", in: testBundle, compatibleWith: nil)!, metadata :nil)
                secondImageMessage?.status = NSNumber(integerLiteral: Int(SENT.rawValue))
                secondImageMessage?.createdAtTime = NSNumber(value: date)
                secondImageMessage?.type = "4"
                
                ALKConversationViewModelMock.testMessages = [firstMessage.messageModel, secondMessage.messageModel, thirdMessage.messageModel, fourthMessage.messageModel, firstImageMessage!.messageModel, secondImageMessage!.messageModel]
                
                conversationVC.viewModel = convVM
                navigationController = ALKBaseNavigationViewController(rootViewController: conversationVC)
            }
            
            it("has all the messages") {
                XCTAssertNotNil(navigationController.view)
                XCTAssertNotNil(conversationVC.view)
                XCTAssertNotNil(conversationVC.navigationController?.view)
                
                // We are not verifying the actual image, just the image message
                // as image is loaded asynchronously so, it will be tested through
                // functional tests.
                expect(conversationVC.navigationController).to(haveValidSnapshot())
            }
        }
        
        describe("Configure NavBar right button") {
            var configuration: ALKConfiguration!
            var conversationVC: ALKConversationViewController!
            var navigationController: UINavigationController!
            
            func prepareController() {
                conversationVC = ALKConversationViewController(configuration: configuration)
                conversationVC.viewModel = ALKConversationViewModelMock(contactId: "demoUserId", channelKey: nil, localizedStringFileName: ALKConfiguration().localizedStringFileName)
                conversationVC.beginAppearanceTransition(true, animated: false)
                conversationVC.endAppearanceTransition()
                navigationController = ALKBaseNavigationViewController(rootViewController: conversationVC)
                self.applyColor(navigationController: navigationController)
            }
            
            it("use system icon") {
                configuration = ALKConfiguration()
                configuration.rightNavBarSystemIconForConversationView = UIBarButtonItem.SystemItem.bookmarks
                
                prepareController()
                
                navigationController.navigationBar.snapshotView(afterScreenUpdates: true)
                expect(navigationController.navigationBar).to(haveValidSnapshot())
            }
            
            it("use image") {
                configuration = ALKConfiguration()
                configuration.isRefreshButtonEnabled = false
                configuration.navigationItemsForConversationView = [
                    ALKNavigationItem(
                        identifier: 123456,
                        icon: UIImage(named: "close", in: Bundle.applozic, compatibleWith: nil)!
                    )]
                prepareController()
                
                navigationController.navigationBar.snapshotView(afterScreenUpdates: true)
                expect(navigationController.navigationBar).to(haveValidSnapshot())
            }
            
            it("hide button") {
                configuration = ALKConfiguration()
                configuration.hideRightNavBarButtonForConversationView = true
                prepareController()
                navigationController.navigationBar.snapshotView(afterScreenUpdates: true)
                expect(navigationController.navigationBar).to(haveValidSnapshot())
            }
        }

        context("when conversation details are not present.") {
            var navigationController: UINavigationController!

            beforeEach {
                let conversationVC = ALKConversationViewController(configuration: ALKConfiguration())
                conversationVC.viewModel = ALKConversationViewModelMock(contactId: nil, channelKey: nil, localizedStringFileName: ALKConfiguration().localizedStringFileName)
                conversationVC.beginAppearanceTransition(true, animated: false)
                conversationVC.endAppearanceTransition()
                navigationController = ALKBaseNavigationViewController(rootViewController: conversationVC)
                self.applyColor(navigationController: navigationController)
            }

            it("shows loading") {
                navigationController.navigationBar.snapshotView(afterScreenUpdates: true)
                expect(navigationController.navigationBar).to(haveValidSnapshot())
            }
        }
    }

    func applyColor(navigationController : UINavigationController)  {
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = UIColor(red:0.10, green:0.65, blue:0.89, alpha:1.0)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor =  UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
            navigationController.navigationBar.standardAppearance = appearance
        }else{
            navigationController.navigationBar.barTintColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        }
    }
}