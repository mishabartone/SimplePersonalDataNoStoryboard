//
//  PersonalDataTableViewCellViewModel.swift
//  PersonalData
//
//  Created by Михаил Железовский on 25.10.2022.
//

import Foundation

protocol PersonalDataTableViewCellViewModelProtocol {
    var deleteHandler: (() -> Void )? { get set }
}

final class PersonalDataTableViewCellViewModel: PersonalDataTableViewCellViewModelProtocol {
    var viewModel: PersonalDataTableViewCellViewModelProtocol?
    var deleteHandler: (() -> Void)? = nil
}
