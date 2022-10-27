//
//  PersonalDataTableViewCell.swift
//  PersonalData
//
//  Created by Михаил Железовский on 25.10.2022.
//

import UIKit

final class PersonalDataTableViewCell: UITableViewCell {
    static let identifier = "Cell"
    
    var viewModel: PersonalDataTableViewCellViewModelProtocol?
    private let nameTextField = UITextField()
    private let ageTextField = UITextField()
    lazy var nameView = createInputView(viewName: "Name", textField: nameTextField)
    lazy var ageView = createInputView(viewName: "Age", textField: ageTextField)
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.addTarget(self, action: #selector(deleteTapButton), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
        viewModel = PersonalDataTableViewCellViewModel()
    }
}

extension PersonalDataTableViewCell {
    @objc
    private func deleteTapButton() {
        viewModel?.deleteHandler?()
    }
    
    private func addSubviews() {
        [nameView, ageView, deleteButton].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        nameView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-150)
            make.height.equalTo(70)
            make.top.equalTo(contentView.snp.top).offset(10)
        }
        ageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.top.equalTo(nameView.snp.bottom).offset(20)
            make.height.equalTo(70)
            make.trailing.equalTo(contentView.snp.trailing).offset(-150)
        }
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(nameView.snp.trailing)
            make.centerY.equalTo(nameView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
    
    private func createInputView(viewName: String, textField: UITextField) -> UIView {
        let view = UIView()
        let label = UILabel()
        let textField = textField
        textField.autocorrectionType = .no
        textField.delegate = self
        
        label.text = viewName
        label.textColor = .lightGray
        
        view.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        view.addSubview(textField)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(15)
            make.top.equalTo(view.snp.top).offset(15)
            make.height.equalTo(15)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(15)
            make.top.equalTo(label.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-5)
        }
        return view
    }
}

extension PersonalDataTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
            ageTextField.becomeFirstResponder()
        case ageTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
