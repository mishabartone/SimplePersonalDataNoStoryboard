//
//  PersonalDataViewController.swift
//  PersonalData
//
//  Created by Михаил Железовский on 25.10.2022.
//

import UIKit
import SnapKit

final class PersonalDataViewController: UIViewController {
    
    private let personalLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Data"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let childrenlLabel: UILabel = {
        let label = UILabel()
        label.text = "Children (max 5)"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+  Add child", for: .normal)
        button.setTitleColor(.systemCyan, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.addTarget(self, action: #selector(tapAddChildren), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField = UITextField()
    private let ageTextField = UITextField()
    private let kidsTableView = UITableView()
    private var viewModel: PersonalDataViewModelProtocol
    
    lazy var nameView = createInputView(viewName: "Name", textField: nameTextField)
    lazy var ageView = createInputView(viewName: "Age", textField: ageTextField)
    
    init(viewModel: PersonalDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setConstraints()
        createChildrenTableView()
    }
}

extension PersonalDataViewController {
    private func setupBind() {
        viewModel.reload = { [weak self] viewmodel in
            DispatchQueue.main.async {
                self?.kidsTableView.reloadData()
                self?.kidsTableView.isHidden = self!.viewModel.isHidenTableAndClearButton
                self?.addButton.isHidden = self!.viewModel.isHidenAddButton
                self?.clearButton.isHidden = self!.viewModel.isHidenTableAndClearButton
            }
        }
    }
    
    @objc
    private func tapClearButton() {
        let alertControl = UIAlertController(title: "Clear", message: "", preferredStyle: .actionSheet)
        let alertClear = UIAlertAction(title: "Clear data", style: .default) { [unowned self]_ in
            self.viewModel.tapClearButton()
            self.nameTextField.text = nil
            self.ageTextField.text = nil
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertControl.addAction(alertClear)
        alertControl.addAction(alertCancel)
        present(alertControl, animated: true)
    }
    
    @objc
    private func tapAddChildren(){
        viewModel.addChildCell()
    }
    
    private func createChildrenTableView () {
        kidsTableView.register(PersonalDataTableViewCell.self, forCellReuseIdentifier: PersonalDataTableViewCell.identifier)
        kidsTableView.delegate = self
        kidsTableView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        kidsTableView.isHidden = true
        clearButton.isHidden = true
    }
    
    private func addSubviews() {
        [personalLabel, nameView, ageView, childrenlLabel, addButton, kidsTableView, clearButton].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        childrenlLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(ageView.snp.bottom).offset(20)
        }
        personalLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
        }
        clearButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(60)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.centerX.equalTo(view.snp.centerX)
        }
        nameView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(70)
            make.top.equalTo(personalLabel.snp.bottom).offset(30)
        }
        ageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(70)
            make.top.equalTo(nameView.snp.bottom).offset(10)
        }
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(childrenlLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.centerY.equalTo(childrenlLabel.snp.centerY)
            make.height.equalTo(50)
        }
        kidsTableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.top.equalTo(childrenlLabel.snp.bottom).offset(20)
            make.bottom.equalTo(clearButton.snp.top).offset(-20)
        }
    }
    
    private func createInputView(viewName: String, textField: UITextField) -> UIView {
        let view = UIView()
        let label = UILabel()
        let textField = textField
        textField.autocorrectionType = .no
        label.text = viewName
        label.textColor = .lightGray
        view.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        textField.delegate = self
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

extension PersonalDataViewController: UITextFieldDelegate {
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

extension PersonalDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonalDataTableViewCell
        cell.selectionStyle = .none
        cell.viewModel?.deleteHandler = { [weak self] in
            self?.viewModel.personalData.remove(at: indexPath.row)
            self?.kidsTableView.reloadData()
            
            if let personalDataCount = self?.viewModel.personalData.count, personalDataCount == 0 {
                self?.clearButton.isHidden = true
                self?.viewModel.isHidenTableAndClearButton = true
                self?.kidsTableView.isHidden = true
            }
        }
        return cell
    }
}

