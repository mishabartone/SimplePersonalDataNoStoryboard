//
//  PersonalDataBuilder.swift
//  PersonalData
//
//  Created by Михаил Железовский on 25.10.2022.
//

import UIKit

protocol PersonalDataBuilder {
    static func createMainScreen() -> UIViewController
}

final class PersonalDataModuleBuilder: PersonalDataBuilder {
    static func createMainScreen() -> UIViewController {
        let viewModel = PersonalDataViewModel()
        let viewController = PersonalDataViewController(viewModel: viewModel)
        return viewController
    }
}
