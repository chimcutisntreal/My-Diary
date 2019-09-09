
import UIKit

class EditAudioViewController: UIViewController {

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var echoSwitch: UISwitch!
    @IBOutlet weak var reverbSwitch: UISwitch!
    
    var rate: Float! = 1
    var pitch: Float! = 0
    var echo: Bool! = false
    var reverb: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        self.rateSlider.value = self.rate
        self.pitchSlider.value = self.pitch
        self.echoSwitch.setOn(self.echo, animated: false)
        self.reverbSwitch.setOn(self.reverb, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
