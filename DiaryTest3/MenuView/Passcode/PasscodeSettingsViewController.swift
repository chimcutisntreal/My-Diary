//
//  PasscodeSettingsViewController.swift
//  PasscodeLockDemo


import UIKit
import PasscodeLock

class PasscodeSettingsViewController: UIViewController {
    @IBOutlet var passcodeSwitch: UISwitch!
    @IBOutlet var changePasscodeButton: UIButton!

    private let configuration: PasscodeLockConfigurationType

    init(configuration: PasscodeLockConfigurationType) {
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        let repository = UserDefaultsPasscodeRepository()
        configuration = PasscodeLockConfiguration(repository: repository)

        super.init(coder: aDecoder)
    }

    // MARK: - View

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePasscodeView()
        setGradient()
    }

    func updatePasscodeView() {
        let hasPasscode = configuration.repository.hasPasscode

        changePasscodeButton.isHidden = !hasPasscode
        passcodeSwitch.isOn = hasPasscode
    }

    // MARK: - Actions

    @IBAction func passcodeSwitchValueChange(sender: UISwitch) {
        let passcodeVC: PasscodeLockViewController

        if passcodeSwitch.isOn {
            passcodeVC = PasscodeLockViewController(state: .set, configuration: configuration)

        } else {
            passcodeVC = PasscodeLockViewController(state: .remove, configuration: configuration)
        }

        present(passcodeVC, animated: true, completion: nil)
    }

    @IBAction func changePasscodeButtonTap(sender: UIButton) {
        let repo = UserDefaultsPasscodeRepository()
        let config = PasscodeLockConfiguration(repository: repo)

        let passcodeLock = PasscodeLockViewController(state: .change, configuration: config)

        present(passcodeLock, animated: true, completion: nil)
    }

}
