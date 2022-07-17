//
//  motorolaCodingChallengeTests.swift
//  motorolaCodingChallengeTests
//
//  Created by Martina on 14/07/22.
//

import XCTest
@testable import motorolaCodingChallenge
import UIKit
import CoreLocation

var incidentListVC = incidentsListViewController()
var incidentListVM = incidentListViewModel()

class motorolaCodingChallengeTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
    }
    
    
    func testDescendingOrder() {
        
        typealias incident = constants.incidentPost
        let date1 = "2022-07-06T11:59:34+1000"
        let date2 = "2022-07-06T12:16:49+1000"
        let firstIncident = incident(title: "", callTime: date1, id: "", latitude: 0.0, longitude: 0.0, description: "", location: "", status: "", type: "", typeIcon: URL(fileURLWithPath: ""))
        let secondIncident = incident(title: "", callTime: date2, id: "", latitude: 0.0, longitude: 0.0, description: "", location: "", status: "", type: "", typeIcon: URL(fileURLWithPath: ""))
        
        
        incidentListViewModel.incidentPosts = [secondIncident, firstIncident]
        let incidents = incidentListViewModel.reorder()
        let incidents2 = incidentListViewModel.reorder()
        
        let firstIncidentIndex = incidents.firstIndex(where: { $0.callTime == firstIncident.callTime }) ?? 0
        let secondIncidentIndex = incidents.firstIndex(where: { $0.callTime == secondIncident.callTime }) ?? 0
        
        let firstIncidentIndex2 = incidents2.firstIndex(where: { $0.callTime == firstIncident.callTime }) ?? 0
        let secondIncidentIndex2 = incidents2.firstIndex(where: { $0.callTime == secondIncident.callTime }) ?? 0
        
        XCTAssert(firstIncidentIndex>secondIncidentIndex)
        XCTAssert(firstIncidentIndex2<secondIncidentIndex2)
        
    }
    
    func testDateFormat() {
        
        let date = "2022-07-06T11:59:34+1000"
        
        let result = constants.dateFormat(date)
        
        XCTAssert(result == "Wed, 6 Jul 2022 at 11:59:34 AM")
        
    }

    func testTableView() {
        
        let vc = incidentsListViewController()
        
        vc.loadDataAPI()
        let n = vc.incidentPosts.count
        
        XCTAssert(n == vc.incidentsTableView.numberOfRows(inSection: 0))
        
    }
    
    func testLoadingViews() {
        
        let vc = incidentsListViewController()
        
        vc.loadDataAPI()
        
        XCTAssert(vc.contains(vc.incidentsTableView) != vc.contains(vc.tryAgainStackView))
    
    }
    

}
