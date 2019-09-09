
import UIKit

class ListAudioTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    struct Alerts {
        static let Error = "An Error Occurred"
        static let DuplicateFileName = "Duplicate File Name"
    }
    
    var audios = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listAudioFiles()
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListAudioTableViewController.longPress(_:)))
        recognizer.minimumPressDuration = 0.5
        recognizer.delegate = self as? UIGestureRecognizerDelegate
        recognizer.delaysTouchesEnded = true
        self.tableView.addGestureRecognizer(recognizer)
        setGradient()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.audios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListAudioTableViewCell", for: indexPath) as! ListAudioTableViewCell
        cell.configure(filename: self.audios[indexPath.row].deletingPathExtension().lastPathComponent)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PlaySelectedAudioSegue", sender: self.audios[indexPath.row])
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alert.showYesNoAlert("Delete", message: "Delete \"\(self.audios[indexPath.row].deletingPathExtension().lastPathComponent)\"?", in: self, completion: {
                self.deleteSingleAudioFile(self.audios[indexPath.row])
            })
        }
    }

    // MARK: - Actions
    
    @IBAction func deleteAllAudios(_ sender: Any) {
        Alert.showYesNoAlert("Delete", message: "Delete all audio files?", in: self, completion: deleteAllAudioFiles)
    }
    
    // MARK: - Helper Functions
    
    func listAudioFiles() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.audios = urls.filter( { (name: URL) -> Bool in
                return name.lastPathComponent.hasSuffix("wav")
            })
        } catch {
            Alert.showDismissAlert(Alerts.Error, message: error.localizedDescription, in: self)
        }
    }
    
    func deleteSingleAudioFile(_ url:URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            Alert.showDismissAlert(Alerts.Error, message: error.localizedDescription, in: self)
        }
        
        DispatchQueue.main.async() {
            self.listAudioFiles()
            self.tableView.reloadData()
        }
    }
    
    func deleteAllAudioFiles() {
        let fileManager = FileManager.default
        
        for i in 0..<self.audios.count {
            do {
                try fileManager.removeItem(at: self.audios[i])
            } catch {
                Alert.showDismissAlert(Alerts.Error, message: error.localizedDescription, in: self)
            }
        }
        
        DispatchQueue.main.async() {
            self.listAudioFiles()
            self.tableView.reloadData()
        }
    }
    
    func renameAudioFile(_ from:URL, to:URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let toURL = documentsDirectory.appendingPathComponent(to.lastPathComponent)
    
        let fileManager = FileManager.default
        fileManager.delegate = self
        
        // Show alert if file name already exists
        if fileManager.fileExists(atPath: toURL.path) {
            Alert.showDismissAlert(Alerts.DuplicateFileName, message: "File name \"\(toURL.deletingPathExtension().lastPathComponent)\" already exists.", in: self)
        }
        
        do {
            try fileManager.moveItem(at: from, to: toURL)
        } catch {
            Alert.showDismissAlert(Alerts.Error, message: error.localizedDescription, in: self)
        }
        
        DispatchQueue.main.async() {
            self.listAudioFiles()
            self.tableView.reloadData()
        }
    }
    
    @objc func longPress(_ sender:UILongPressGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        let row = sender.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: row) {
            let audio = self.audios[indexPath.row]
            let alert = UIAlertController(title: "Rename", message: "Rename Recording \"\(audio.deletingPathExtension().lastPathComponent)\"?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                if let textFields = alert.textFields {
                    let fileNameTextField = textFields as [UITextField]
                    let url = URL(fileURLWithPath: "\(fileNameTextField[0].text!).wav")
                    self.renameAudioFile(audio, to: url)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            alert.addTextField(configurationHandler: {textfield in
                textfield.placeholder = "Enter a filename"
                textfield.text = audio.deletingPathExtension().lastPathComponent
            })
            self.present(alert, animated:true, completion:nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySelectedAudioSegue" {
            let playAudioVC = segue.destination as! PlayAudioViewController
            let audioURL = sender as! URL
            playAudioVC.recordedAudioURL = audioURL
        }
    }

}
