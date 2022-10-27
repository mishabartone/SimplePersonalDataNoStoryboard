//
//  PersonalDataViewModel.swift
//  PersonalData
//
//  Created by Михаил Железовский on 25.10.2022.
//

import Foundation

protocol PersonalDataViewModelProtocol: AnyObject {
    var personalData: [PersonalDataModel] {get set}
    var reload: ((PersonalDataViewModelProtocol) -> Void)? {get set}
    var isHidenAddButton: Bool {get set}
    var isHidenTableAndClearButton: Bool {get set}
    func numberOfRows () -> Int
    func addChildCell ()
    func tapClearButton()
}

final class PersonalDataViewModel: PersonalDataViewModelProtocol {
    var isHidenAddButton: Bool  = false
    var isHidenTableAndClearButton: Bool = true
    var reload: ((PersonalDataViewModelProtocol) -> Void)?
    
    var personalData: [PersonalDataModel] = [] {
        willSet {
            switch personalData.count {
            case _ where personalData.count <= 5 :
                reload?(self)
                isHidenTableAndClearButton = false
                isHidenAddButton = false
            default:
                break
            }
        }
    }

    func addChildCell() {
        personalData.append(PersonalDataModel(name: "", age: 0))
        if personalData.count >= 5 {
            reload?(self)
            isHidenAddButton = true
        }
    }
    
    func numberOfRows() -> Int {
        personalData.count
    }
    
    func tapClearButton() {
        personalData = []
        isHidenTableAndClearButton = true
        isHidenAddButton = false
        reload?(self)
    }
}
