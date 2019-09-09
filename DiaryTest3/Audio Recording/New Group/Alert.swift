
import UIKit

public class Alert {
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
    }
    
    class func showDismissAlert(_ title: String, message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showYesNoAlert(_ title: String, message: String, in viewController: UIViewController, completion:(() -> Void)!) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        viewController.present(alert, animated:true, completion:nil)
    }
}
